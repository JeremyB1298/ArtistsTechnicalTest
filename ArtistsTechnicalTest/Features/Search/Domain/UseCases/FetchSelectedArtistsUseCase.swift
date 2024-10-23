//
//  FetchSelectedArtistsUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - FetchSelectedArtistsUseCase

/// A protocol defining the requirements for fetching selected artists.
/// This protocol provides a method to retrieve an array of selected artists.
protocol FetchSelectedArtistsUseCase {
    /// Retrieves an array of selected artists.
    /// - Returns: An array of `Artist`objects that have been selected.
    func invoke() -> [Artist]
}

// MARK: - FetchSelectedArtistsUseCaseImpl

/// A final implementation of the `FetchSelectedArtistsUseCase`protocol.
/// This class uses an `ArtistRepository`to fetch the selected artists from the data store.
final class FetchSelectedArtistsUseCaseImpl: FetchSelectedArtistsUseCase {
    
    // MARK: - Private property
    
    /// The repository used for accessing artist data.
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    /// Initializes the use case with a given artist repository.
    /// - Parameter repository: The `ArtistRepository` used to fetch selected artists.
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    /// Retrieves an array of selected artists.
    /// - Returns: An array of `Artist`objects that have been selected.
    func invoke() -> [Artist] {
        
        // Fetch and return the selected artists from the repository
        repository.fetchSelectedArtists()
    }
    
}
