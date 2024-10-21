//
//  SearchArtistsViewModel.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import Foundation

// MARK: - SearchArtistsViewModel

protocol SearchArtistsViewModel {
    var artists: [ArtistUIModel] { get }
    func search(query: String, _ completion: @escaping (Result<[ArtistUIModel], AppError>) -> Void)
}

// MARK: - SearchArtistsViewModelImpl

final class SearchArtistsViewModelImpl: SearchArtistsViewModel {
    
    // MARK: - Private properties
    
    private let searchArtistsUseCase: SearchArtistsUseCase
    private let mapper: ArtistUIMapper
    
    // MARK: - Public property
    
    var artists: [ArtistUIModel] = []
    
    // MARK: - Initializer
    
    init(searchArtistsUseCase: SearchArtistsUseCase, mapper: ArtistUIMapper) {
        self.searchArtistsUseCase = searchArtistsUseCase
        self.mapper = mapper
    }
    
    // MARK: - Public method
    
    func search(query: String, _ completion: @escaping (Result<[ArtistUIModel], AppError>) -> Void) {
        guard query.count > 2 else {
            return completion(.success([]))
        }
        
        Task { [weak self] in
            guard let self else { return }
            do {
                let artists = try await searchArtistsUseCase.invoke(query: query)
                self.artists = artists.map(mapper.map(artist:))
                
                DispatchQueue.main.async {
                    completion(.success(self.artists))
                }
            } catch let error as AppError {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
