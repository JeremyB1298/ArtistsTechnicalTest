//
//  ResetSelectedArtistsUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

// MARK: - ResetSelectedArtistsUseCase

protocol ResetSelectedArtistsUseCase {
    func invoke()
}

// MARK: - ResetSelectedArtistsUseCaseImpl

final class ResetSelectedArtistsUseCaseImpl: ResetSelectedArtistsUseCase {
    
    // MARK: - Private property
    
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    func invoke() {
        repository.resetSelectedArtists()
    }
    
}
