//
//  DeselectArtistUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - DeselectArtistUseCase

/// A protocol defining the requirements for deselecting an artist.
/// This protocol provides a method to remove the selection of an artist.
protocol DeselectArtistUseCase {
    /// Deselects an artist and removes it from the repository.
    /// - Parameter artist: The `Artist` object to be deselected and unregistered.
    /// - Returns: The updated `Artist`object with the selection status set to false.
    func invoke(artist: Artist) -> Artist
}

// MARK: - DeselectArtistUseCaseImpl

/// A final implementation of the `DeselectArtistUseCase`protocol.
/// This class uses an `ArtistRepository`to handle the deselection and unregistration of an artist.
final class DeselectArtistUseCaseImpl: DeselectArtistUseCase {
    
    // MARK: - Private property
    
    /// The repository used for managing artist data.
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    /// Initializes the use case with a given artist repository.
    /// - Parameter repository: The `ArtistRepository` used for deselecting and unregistering artists.
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    /// Deselects an artist and removes it from the repository.
    /// - Parameter artist: The `Artist` object to be deselected and unregistered.
    /// - Returns: The updated `Artist`object with the selection status set to false.
    func invoke(artist: Artist) -> Artist {
        
        // Deselect the artist and return the updated artist
        repository.deselectAndUnregister(artist: artist)
    }
    
}
