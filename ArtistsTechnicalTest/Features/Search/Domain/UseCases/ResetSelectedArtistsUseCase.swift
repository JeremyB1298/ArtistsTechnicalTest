//
//  ResetSelectedArtistsUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

// MARK: - ResetSelectedArtistsUseCase

/// A protocol defining the requirements for resetting selected artists.
/// This protocol provides a method to clear the selection of all artists.
protocol ResetSelectedArtistsUseCase {
    
    /// Reset the selection of artists.
    func invoke()
}

// MARK: - ResetSelectedArtistsUseCaseImpl

/// A final implementation of `ResetSelectedArtistUseCase`protocol.
/// This class uses an `ArtistRepository`to handle the reset of selected artists.
final class ResetSelectedArtistsUseCaseImpl: ResetSelectedArtistsUseCase {
    
    // MARK: - Private property
    
    /// The repository used for managing artist data.
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    /// Initializes the use case with a given artist repository.
    /// - Parameter repository: The `ArtistRepository` used for resetting selected artists.
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    /// Reset the selection of artists.
    func invoke() {
        
        // Clear the selection of all artists in the repository
        repository.resetSelectedArtists()
    }
    
}
