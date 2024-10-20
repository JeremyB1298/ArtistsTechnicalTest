//
//  SelectArtistUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - SelectArtistUseCase

protocol SelectArtistUseCase {
    func invoke(artist: Artist) -> Artist
}

// MARK: - SelectArtistUseCaseImpl

final class SelectArtistUseCaseImpl: SelectArtistUseCase {
    
    // MARK: - Private property
    
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    func invoke(artist: Artist) -> Artist {
        repository.selectAndSave(artist: artist)
    }
    
}
