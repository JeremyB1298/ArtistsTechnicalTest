//
//  SearchArtistsViewModel.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import Foundation

// MARK: - SearchState

enum SearchState {
    case results
    case selected
}

// MARK: - SearchArtistsViewModel

protocol SearchArtistsViewModel {
    var searchState: SearchState { get }
    var uiArtists: [ArtistUIModel] { get }
    var showCount: Int { get }
    var isResetEnabled: Bool { get }
    func search(query: String, _ completion: @escaping (Result<Void, AppError>) -> Void)
    func updateSelectStatus(for id: Int, with isSelected: Bool)
    func switchSearchState()
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
    
    func search(query: String, _ completion: @escaping (Result<Void, AppError>) -> Void) {
        guard query.count > 2 else {
            searchArtists = []
            return completion(.success(Void()))
        }
        
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
    
    func updateSelectStatus(for id: Int, with isSelected: Bool) {
        switch searchState {
        case .results:
            updateSelectStatus(for: id, with: isSelected, artists: &searchArtists)
        case .selected:
            updateSelectStatus(for: id, with: isSelected, artists: &selectedArtists)
        }
        
        fetchSelectedArtists()
    }
    
    func switchSearchState() {
        switch searchState {
        case .results:
            searchState = .selected
        case .selected:
            searchState = .results
        }
    }
    
    func reset() {
        resetSelectedArtistsUseCase.invoke()
        searchState = .results
        searchArtists = []
        selectedArtists = []
    }
    
    // MARK: - Private methods
    
    private func updateSelectStatus(for id: Int, with isSelected: Bool, artists: inout [Artist]) {
        guard
            let artist = artists.first(where: { $0.id == id }),
            let artistIndex = artists.firstIndex(where: { $0.id == id })
        else {
            fatalError("Error") // TODO: throw ?
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
