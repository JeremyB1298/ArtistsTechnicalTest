//
//  SelectArtistUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - SelectArtistUseCase

/// A protocol defining the requirements for selecting an artists.
/// This protocol provides a method to save the selected artist.
protocol SelectArtistUseCase {
    /// Selects an artist and saves it to the repository.
    /// - Parameter artist: The `Artist`object to be selected and saved.
    /// - Returns: The updated `Artist`object with the selection status.
    func invoke(artist: Artist) -> Artist
}

// MARK: - SelectArtistUseCaseImpl

/// A final implementation of the `SelectArtistUseCase`protocol.
/// This class uses an `ArtistRepository`to handle the selection and saving of an artist.
final class SelectArtistUseCaseImpl: SelectArtistUseCase {
    
    // MARK: - Private property
    
    /// The repository used for managing artist data.
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    /// Initializes the use case with a given artist repository.
    /// - Parameter repository: The `ArtistRepository` used for selecting and saving artists.
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    /// Selects an artist and saves it to the repository.
    /// - Parameter artist: The `Artist`object to be selected and saved.
    /// - Returns: The updated `Artist`object with the selection status.
    func invoke(artist: Artist) -> Artist {
        
        // Save the selected artist using the repository and return the updated artist
        repository.selectAndSave(artist: artist)
    }
    
}
