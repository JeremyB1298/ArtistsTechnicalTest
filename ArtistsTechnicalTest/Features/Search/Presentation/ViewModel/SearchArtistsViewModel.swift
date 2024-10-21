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
    var uiSearchArtists: [ArtistUIModel] { get }
    var uiSelectedArtists: [ArtistUIModel] { get }
    func search(query: String, _ completion: @escaping (Result<Void, AppError>) -> Void)
    func updateSelectStatus(for id: Int, with isSelected: Bool)
    func switchSearchState()
}

// MARK: - SearchArtistsViewModelImpl

final class SearchArtistsViewModelImpl: SearchArtistsViewModel {
    
    // MARK: - Private properties
    
    private let searchArtistsUseCase: SearchArtistsUseCase
    private let selectArtistUseCase: SelectArtistUseCase
    private let deselectArtistUseCase: DeselectArtistUseCase
    private let fetchSelectedArtistsUseCase: FetchSelectedArtistsUseCase
    private let mapper: ArtistUIMapper
    private var searchArtists: [Artist] = []
    private var selectedArtists: [Artist] = []
    
    // MARK: - Public property
    
    var uiSearchArtists: [ArtistUIModel] = []
    var uiSelectedArtists: [ArtistUIModel] = []
    var searchState: SearchState = .results
    
    // MARK: - Initializer
    
    init(
        searchArtistsUseCase: SearchArtistsUseCase,
        mapper: ArtistUIMapper,
        selectArtistUseCase: SelectArtistUseCase,
        deselectArtistUseCase: DeselectArtistUseCase,
        fetchSelectedArtistsUseCase: FetchSelectedArtistsUseCase
    ) {
        self.searchArtistsUseCase = searchArtistsUseCase
        self.mapper = mapper
        self.selectArtistUseCase = selectArtistUseCase
        self.deselectArtistUseCase = deselectArtistUseCase
        self.fetchSelectedArtistsUseCase = fetchSelectedArtistsUseCase
    }
    
    // MARK: - Public methods
    
    func search(query: String, _ completion: @escaping (Result<Void, AppError>) -> Void) {
        guard query.count > 2 else {
            searchArtists = []
            uiSearchArtists = []
            return completion(.success(Void()))
        }
        
        Task { [weak self] in
            guard let self else { return }
            do {
                searchArtists = try await searchArtistsUseCase.invoke(query: query)
                uiSearchArtists = searchArtists.map(mapper.map(artist:))
                
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
            updateSelectStatus(for: id, with: isSelected, artists: &searchArtists, uiArtists: &uiSearchArtists)
        case .selected:
            updateSelectStatus(for: id, with: isSelected, artists: &selectedArtists, uiArtists: &uiSelectedArtists)
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
    
    // MARK: - Private methods
    
    private func updateSelectStatus(for id: Int, with isSelected: Bool, artists: inout [Artist], uiArtists: inout [ArtistUIModel]) {
        guard
            let artist = artists.first(where: { $0.id == id }),
            let artistIndex = artists.firstIndex(where: { $0.id == id }),
            let uiArtistIndex = uiArtists.firstIndex(where: { $0.id == id })
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
        uiArtists[uiArtistIndex] = mapper.map(artist: artistUpdated)
    }
    
    private func fetchSelectedArtists() {
        selectedArtists = fetchSelectedArtistsUseCase.invoke()
        uiSelectedArtists = selectedArtists.map(mapper.map(artist:))
    }
    
}
