//
//  SearchArtistsUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - SearchArtistsUseCase

protocol SearchArtistsUseCase {
    func invoke(query: String) async throws -> [Artist]
}

// MARK: - SearchArtistsUseCaseImpl

final class SearchArtistsUseCaseImpl: SearchArtistsUseCase {
    
    // MARK: - Private property
    
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    func invoke(query: String) async throws -> [Artist] {
        try await repository.fetch(query: query)
    }
    
}
