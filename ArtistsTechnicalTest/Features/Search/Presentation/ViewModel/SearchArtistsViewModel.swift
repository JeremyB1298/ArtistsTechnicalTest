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
    
    /// The current search state, defaulting to showing results.
    var searchState: SearchState { get }
    
    /// The list of UI models representing artists based on the current search state.
    var uiArtists: [ArtistUIModel] { get }
    
    /// The count of artists to display based on the current search state.
    var showCount: Int { get }
    
    /// Indicates if the reset button should be enabled based on the selection status.
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
    
    /// Use cases for searching artists and managing selections.
    private let searchArtistsUseCase: SearchArtistsUseCase & QueryValidator
    
    /// Use case for selecting an artist.
    private let selectArtistUseCase: SelectArtistUseCase
    
    /// Use case for deselecting an artist.
    private let deselectArtistUseCase: DeselectArtistUseCase
    
    /// Use case for fetching selected artists.
    private let fetchSelectedArtistsUseCase: FetchSelectedArtistsUseCase
    
    /// Use case for resetting selected artists.
    private let resetSelectedArtistsUseCase: ResetSelectedArtistsUseCase
    
    /// Mapper for converting domain models to UI models.
    private let mapper: ArtistUIMapper
    
    // The array of search results.
    private var searchArtists: [Artist] = []
    
    /// The array of currently selected artists.
    private var selectedArtists: [Artist] = []
    
    /// Timer for delaying search requests.
    private var searchTimer: AnyCancellable?
    
    /// Delay in milliseconds for search request.
    private let searchRequestDelay = 500
    
    // MARK: - Public property
    
    /// The list of UI models representing artists based on the current search state.
    /// This property transforms the array of `Artist` objects into an array of `ArtistUIModel`
    /// using the provided `ArtistUIMapper`. The contents of this property change depending
    /// on the current search state (results or selected).
    var uiArtists: [ArtistUIModel] {
        switch searchState {
        case .results:
            return searchArtists.map(mapper.map(artist:))
        case .selected:
            return selectedArtists.map(mapper.map(artist:))
        }
    }
    
    /// The current search state, defaulting to showing results.
    var searchState: SearchState = .results
    
    /// The count of artists to display based on the current search state.
    /// This property returns the number of selected artists when in the `.selected` state
    /// and the number of search results when in the `.results` state.
    var showCount: Int {
        switch searchState {
        case .results:
            return selectedArtists.count
        case .selected:
            return searchArtists.count
        }
    }
    
    /// Indicates if the reset button should be enabled based on the selection status.
    var isResetEnabled: Bool {
        !selectedArtists.isEmpty
    }
    
    // MARK: - Initializer
    
    /// Initializes the view model with the necessary use cases and a mapper.
    ///
    /// This initializer sets up the `SearchArtistsViewModelImpl` with all required dependencies,
    /// including use cases for searching, selecting, deselecting, and fetching selected artists,
    /// as well as a mapper for converting domain models to UI models.
    ///
    /// - Parameters:
    ///   - searchArtistsUseCase: A use case for searching artists, which also conforms to `QueryValidator`
    ///                           for validating search queries.
    ///   - mapper: An instance of `ArtistUIMapper` used to convert `Artist` objects to `ArtistUIModel`
    ///             objects for presentation in the UI.
    ///   - selectArtistUseCase: A use case for handling the selection of artists.
    ///   - deselectArtistUseCase: A use case for handling the deselection of artists.
    ///   - fetchSelectedArtistsUseCase: A use case for fetching the currently selected artists.
    ///   - resetSelectedArtistsUseCase: A use case for resetting the selected artists.
    init(
        searchArtistsUseCase: SearchArtistsUseCase & QueryValidator,
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
        
        // Cancel any existing search timer
        searchTimer?.cancel()
        
        // Validate the search query
        guard searchArtistsUseCase.isValid(query: query) else {
            searchArtists = []
            return completion(.success(Void()))
        }
        
        // Set up a timer to delay the search request
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
        
        // Update the selection status in the search results array
        updateSelectStatus(for: id, with: isSelected, artists: &searchArtists)
        
        // Update the selection status in the selected artists array
        updateSelectStatus(for: id, with: isSelected, artists: &selectedArtists)
        
        // Fetch the updated list of selected artists to reflect changes
        fetchSelectedArtists()
    }
    
    /// Switches the search state between results and selected.
    func switchSearchState() {
        
        // Toggle the search state based on the current value
        searchState = (searchState == .results) ? .selected : .results
    }
    
    /// Resets the selected artists and search state.
    func reset() {
        
        // Invoke the use case to reset the selected artists in the repository
        resetSelectedArtistsUseCase.invoke()
        
        // Reset the search state to show results
        searchState = .results
        
        // Clear the search and selected artist arrays
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
                
                // Perform the search and update the searchArtists array
                searchArtists = try await searchArtistsUseCase.invoke(query: query)
                
                // Return success
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch let error as AppError {
                
                // Return failure with the error
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
        
        // Find the artist with its id
        guard
            let artist = artists.first(where: { $0.id == id }),
            let artistIndex = artists.firstIndex(where: { $0.id == id })
        else {
            return
        }
        
        // Update the artist's selection status
        let artistUpdated: Artist
        
        if isSelected {
            artistUpdated = selectArtistUseCase.invoke(artist: artist)
        } else {
            artistUpdated = deselectArtistUseCase.invoke(artist: artist)
        }
        
        // Replace the artist in the array
        artists[artistIndex] = artistUpdated
    }
    
    private func fetchSelectedArtists() {
        // Update the selected artists array
        selectedArtists = fetchSelectedArtistsUseCase.invoke()
    }
    
}
