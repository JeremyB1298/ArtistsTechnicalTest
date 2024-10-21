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
    func saveArtist(artist: Artist) -> Artist
    func removeArtist(id: Int)
    func getSavedArtistIds() -> [Int]
    func getSavedArtists() -> [Artist]
    func reset()
}

// MARK: - ArtistDataStoreImpl

/// A final implementation of the `ArtistDataStore` protocol.
/// This class manages the storage of artist data in memory.
final class ArtistDataStoreImpl: ArtistDataStore {
    
    // MARK: - Private property
    
    private var artistsSaved: [Artist] = []
    
    // MARK: - Public methods
    
    /// Saves an artist to the data store.
    /// - Parameter artist: The artist to be saved.
    func saveArtist(artist: Artist) -> Artist {
        artistsSaved.append(artist)
        return artist
    }
    
    /// Removes an artist from the data store by its identifier.
    /// - Parameter id: The identifier of the artist to be removed.
    func removeArtist(id: Int) {
        artistsSaved.removeAll(where: { $0.id == id })
    }
    
    /// Retrieves an array of saved artist identifiers.
    /// - Returns: An array of integers representing the IDs of saved artists.
    func getSavedArtistIds() -> [Int] {
        artistsSaved.map({ $0.id })
    }
    
    /// Retrieves an array of all saved artists from the data store.
    /// - Returns: An array of `Artist` objects that have been saved.
    func getSavedArtists() -> [Artist] {
        artistsSaved
    }
    
    func reset() {
        artistsSaved.removeAll()
    }
    
}
