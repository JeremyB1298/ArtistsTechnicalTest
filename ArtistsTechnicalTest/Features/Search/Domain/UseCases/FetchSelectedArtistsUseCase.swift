//
//  FetchSelectedArtistsUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - FetchSelectedArtistsUseCase

protocol FetchSelectedArtistsUseCase {
    func invoke() -> [Artist]
}

// MARK: - FetchSelectedArtistsUseCaseImpl

final class FetchSelectedArtistsUseCaseImpl: FetchSelectedArtistsUseCase {
    
    // MARK: - Private property
    
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    func invoke() -> [Artist] {
        repository.fetchSelectedArtists()
    }
    
}
