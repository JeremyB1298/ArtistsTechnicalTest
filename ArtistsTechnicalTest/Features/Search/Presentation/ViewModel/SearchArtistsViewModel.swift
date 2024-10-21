//
//  SearchArtistsViewModel.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import Foundation

// MARK: - SearchArtistsViewModel

protocol SearchArtistsViewModel {
    var uiArtists: [ArtistUIModel] { get }
    func search(query: String, _ completion: @escaping (Result<Void, AppError>) -> Void)
    func updateSelectStatus(for id: Int, with isSelected: Bool)
}

// MARK: - SearchArtistsViewModelImpl

final class SearchArtistsViewModelImpl: SearchArtistsViewModel {
    
    // MARK: - Private properties
    
    private let searchArtistsUseCase: SearchArtistsUseCase
    private let selectArtistUseCase: SelectArtistUseCase
    private let deselectArtistUseCase: DeselectArtistUseCase
    private let mapper: ArtistUIMapper
    private var artists: [Artist] = []
    
    // MARK: - Public property
    
    var uiArtists: [ArtistUIModel] = []
    
    // MARK: - Initializer
    
    init(
        searchArtistsUseCase: SearchArtistsUseCase,
        mapper: ArtistUIMapper,
        selectArtistUseCase: SelectArtistUseCase,
        deselectArtistUseCase: DeselectArtistUseCase
    ) {
        self.searchArtistsUseCase = searchArtistsUseCase
        self.mapper = mapper
        self.selectArtistUseCase = selectArtistUseCase
        self.deselectArtistUseCase = deselectArtistUseCase
    }
    
    // MARK: - Public methods
    
    func search(query: String, _ completion: @escaping (Result<Void, AppError>) -> Void) {
        guard query.count > 2 else {
            artists = []
            uiArtists = []
            return completion(.success(Void()))
        }
        
        Task { [weak self] in
            guard let self else { return }
            do {
                artists = try await searchArtistsUseCase.invoke(query: query)
                uiArtists = artists.map(mapper.map(artist:))
                
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
    
}
