//
//  UnselectArtistUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - UnselectArtistUseCase

protocol UnselectArtistUseCase {
    func invoke(artist: Artist) -> Artist
}

// MARK: - UnselectArtistUseCaseImpl

final class UnselectArtistUseCaseImpl: UnselectArtistUseCase {
    
    // MARK: - Private property
    
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    func invoke(artist: Artist) -> Artist {
        repository.unselectAndUnregister(artist: artist)
    }
    
}
