//
//  DeselectArtistUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - DeselectArtistUseCase

protocol DeselectArtistUseCase {
    func invoke(artist: Artist) -> Artist
}

// MARK: - DeselectArtistUseCaseImpl

final class DeselectArtistUseCaseImpl: DeselectArtistUseCase {
    
    // MARK: - Private property
    
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    func invoke(artist: Artist) -> Artist {
        repository.deselectAndUnregister(artist: artist)
    }
    
}
