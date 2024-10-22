//
//  SearchArtistsViewModel.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import Foundation
import Combine

// MARK: - SearchState

/// An enumeration representing the current state of the search.
/// The state can be either showing search results or selected artists.
enum SearchState {
    case results
    case selected
}

// MARK: - SearchArtistsViewModel

/// A protocol defining the requirements for the search artists view model.
/// This protocol provides properties and methods for managing the artist search and selection.
protocol SearchArtistsViewModel {
    var searchState: SearchState { get }
    var uiArtists: [ArtistUIModel] { get }
    var showCount: Int { get }
    var isResetEnabled: Bool { get }
    
    /// Searches for artists based on the provided query and invokes the completion handler with the result.
    /// - Parameters:
    ///   - query: The search query for finding artists.
    ///   - completion: A completion handler to handle the result of the search.
    func search(query: String, _ completion: @escaping (Result<Void, AppError>) -> Void)
    
    /// Updates the selection status of an artist by its ID.
    /// - Parameters:
    ///   - id: The ID of the artist to update.
    ///   - isSelected: The new selection status for the artist.
    func updateSelectStatus(for id: Int, with isSelected: Bool)
    
    /// Switches the search state between results and selected.
    func switchSearchState()
    
    /// Resets the selected artists and search state.
    func reset()
}

// MARK: - SearchArtistsViewModelImpl

final class SearchArtistsViewModelImpl: SearchArtistsViewModel {
    
    // MARK: - Private properties
    
    private let searchArtistsUseCase: SearchArtistsUseCase
    private let selectArtistUseCase: SelectArtistUseCase
    private let deselectArtistUseCase: DeselectArtistUseCase
    private let fetchSelectedArtistsUseCase: FetchSelectedArtistsUseCase
    private let resetSelectedArtistsUseCase: ResetSelectedArtistsUseCase
    private let mapper: ArtistUIMapper
    private var searchArtists: [Artist] = []
    private var selectedArtists: [Artist] = []
    private var searchTimer: AnyCancellable?
    private let searchRequestDelay = 300
    
    // MARK: - Public property
    
    var uiArtists: [ArtistUIModel] {
        switch searchState {
        case .results:
            return searchArtists.map(mapper.map(artist:))
        case .selected:
            return selectedArtists.map(mapper.map(artist:))
        }
    }
    var searchState: SearchState = .results
    var showCount: Int {
        switch searchState {
        case .results:
            return selectedArtists.count
        case .selected:
            return searchArtists.count
        }
    }
    var isResetEnabled: Bool {
        !selectedArtists.isEmpty
    }
    
    // MARK: - Initializer
    
    init(
        searchArtistsUseCase: SearchArtistsUseCase,
        mapper: ArtistUIMapper,
        selectArtistUseCase: SelectArtistUseCase,
        deselectArtistUseCase: DeselectArtistUseCase,
        fetchSelectedArtistsUseCase: FetchSelectedArtistsUseCase,
        resetSelectedArtistsUseCase: ResetSelectedArtistsUseCase
    ) {
        self.searchArtistsUseCase = searchArtistsUseCase
        self.mapper = mapper
        self.selectArtistUseCase = selectArtistUseCase
        self.deselectArtistUseCase = deselectArtistUseCase
        self.fetchSelectedArtistsUseCase = fetchSelectedArtistsUseCase
        self.resetSelectedArtistsUseCase = resetSelectedArtistsUseCase
    }
    
    // MARK: - Public methods
    
    /// Searches for artists based on the provided query and invokes the completion handler with the result.
    /// - Parameters:
    ///   - query: The search query for finding artists.
    ///   - completion: A completion handler to handle the result of the search.
    func search(query: String, _ completion: @escaping (Result<Void, AppError>) -> Void) {
        
        searchTimer?.cancel()
        
        searchTimer = Just(query)
            .delay(for: .milliseconds(searchRequestDelay), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.performSearch(query: query, completion)
            }
    }
    
    /// Updates the selection status of an artist by its ID.
    /// - Parameters:
    ///   - id: The ID of the artist to update.
    ///   - isSelected: The new selection status for the artist.
    func updateSelectStatus(for id: Int, with isSelected: Bool) {
        switch searchState {
        case .results:
            updateSelectStatus(for: id, with: isSelected, artists: &searchArtists)
        case .selected:
            updateSelectStatus(for: id, with: isSelected, artists: &selectedArtists)
        }
        
        fetchSelectedArtists()
    }
    
    /// Switches the search state between results and selected.
    func switchSearchState() {
        switch searchState {
        case .results:
            searchState = .selected
        case .selected:
            searchState = .results
        }
    }
    
    /// Resets the selected artists and search state.
    func reset() {
        resetSelectedArtistsUseCase.invoke()
        searchState = .results
        searchArtists = []
        selectedArtists = []
    }
    
    // MARK: - Private methods
    
    /// Performs the actual search operation and handles the results.
    /// - Parameters:
    ///   - query: The search query to use for the search.
    ///   - completion: A completion handler to handle the result of the search.
    private func performSearch(query: String, _ completion: @escaping (Result<Void, AppError>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                searchArtists = try await searchArtistsUseCase.invoke(query: query)
                
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch let error as AppError {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Updates the selection status of an artist in the specified list.
    /// - Parameters:
    ///   - id: The ID of the artist to update.
    ///   - isSelected: The new selection status for the artist.
    ///   - artists: The list of artists to update.
    private func updateSelectStatus(for id: Int, with isSelected: Bool, artists: inout [Artist]) {
        guard
            let artist = artists.first(where: { $0.id == id }),
            let artistIndex = artists.firstIndex(where: { $0.id == id })
        else {
            return
        }
        
        let artistUpdated: Artist
        
        if isSelected {
            artistUpdated = selectArtistUseCase.invoke(artist: artist)
        } else {
            artistUpdated = deselectArtistUseCase.invoke(artist: artist)
        }
        
        artists[artistIndex] = artistUpdated
    }
    
    private func fetchSelectedArtists() {
        selectedArtists = fetchSelectedArtistsUseCase.invoke()
    }
    
}
