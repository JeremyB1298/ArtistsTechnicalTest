//
//  ArtistDataStore.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - ArtistDataStore

/// A protocol defining the requirements for an artist data store.
/// This protocol provides methods for saving, removing, and retrieving artist information.
protocol ArtistDataStore {
    
    /// Saves an artist to the data store.
    /// - Parameter artist: The artist to be saved.
    /// - Returns: The saved artist object.
    func saveArtist(artist: Artist) -> Artist
    
    /// Removes an artist from the data store by its identifier
    /// - Parameter id: The identifier of the artist to be removed.
    func removeArtist(id: Int)
    
    /// Retrieves an array of saved artist identifiers.
    /// - Returns: An array of integers representing the IDs of saved artists.
    func getSavedArtistIds() -> [Int]
    
    /// Retrieves an array of all saved artists from the data store.
    /// - Returns: An array of `Artist`objects that have been saved.
    func getSavedArtists() -> [Artist]
    
    /// Resets the data store, clearing all saved artists.
    func reset()
}

// MARK: - ArtistDataStoreImpl

/// A final implementation of the `ArtistDataStore` protocol.
/// This class manages the storage of artist data in memory.
final class ArtistDataStoreImpl: ArtistDataStore {
    
    // MARK: - Private property
    
    /// An array that holds all saved artists.
    private var artistsSaved: [Artist] = []
    
    // MARK: - Public methods
    
    /// Saves an artist to the data store.
    /// - Parameter artist: The artist to be saved.
    /// - Returns: The saved artist object.
    func saveArtist(artist: Artist) -> Artist {
        // Add the artist to the saved artists array
        artistsSaved.append(artist)
        // Return the saved artist
        return artist
    }
    
    /// Removes an artist from the data store by its identifier
    /// - Parameter id: The identifier of the artist to be removed.
    func removeArtist(id: Int) {
        // Remove all artists with the matching ID
        artistsSaved.removeAll(where: { $0.id == id })
    }
    
    /// Retrieves an array of saved artist identifiers.
    /// - Returns: An array of integers representing the IDs of saved artists.
    func getSavedArtistIds() -> [Int] {
        // Map the saved artists to their IDs
        artistsSaved.map({ $0.id })
    }
    
    /// Retrieves an array of all saved artists from the data store.
    /// - Returns: An array of `Artist`objects that have been saved.
    func getSavedArtists() -> [Artist] {
        // Return the array of saved artists
        artistsSaved
    }
    
    /// Resets the data store, clearing all saved artists.
    func reset() {
        // Clear all saved artists
        artistsSaved.removeAll()
    }
    
}
