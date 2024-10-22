//
//  ArtistRepository.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// A protocol defining the requirements for an artist repository.
/// This protocol provides methods for fetching and saving artist data.
protocol ArtistRepository {
    
    /// Fetches a list of artists based on the provided query.
    /// - Parameter query: The search query used to find artists.
    /// - Returns: An array of `Artist`objects that match the search query.
    /// - Throws: An error if the fetch operation fails, such as network errors or data parsing issues.
    func fetch(query: String) async throws -> [Artist]
    
    /// Selects an artist and saves it to the repository.
    /// - Parameter artist: The artist to be selected and saved.
    /// - Returns: The updated artist object, possibly with modified properties (e.g., isSelected).
    func selectAndSave(artist: Artist) -> Artist
    
    /// Deselects an artist and unregisters it from the repository.
    /// - Parameter artist: The artist to be deselected and unregistered.
    /// - Returns: The updated artist object, possibly with modified properties (e.g., isSelected).
    func deselectAndUnregister(artist: Artist) -> Artist
    
    /// Fetches a list of currently selected artists.
    /// - Returns: An array of `Artist`objects that are currently selected.
    func fetchSelectedArtists() -> [Artist]
    
    /// Resets the list of selected artists, clearing any current selections.
    func resetSelectedArtists()
}
