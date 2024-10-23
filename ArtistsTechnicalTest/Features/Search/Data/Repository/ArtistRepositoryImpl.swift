//
//  ArtistRepositoryImpl.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

import Foundation

/// A final implementation of the `ArtistRepository` protocol that handles artist data retrieval.
/// This class uses a service for network operations and a mapper to convert DTOs to domain models.
final class ArtistRepositoryImpl: ArtistRepository {
    
    // MARK: - Private properties
    
    /// The service responsible for handling network operations.
    private let service: Service
    
    /// The mapper that converts DTOs to domain models for artists.
    private let artistMapper: ArtistMapper
    
    /// The mapper that converts service errors to user-friendly errors.
    private let errorMapper: ErrorMapper
    
    /// The data store for saving and retrieving artist data.
    private let dataStore: ArtistDataStore
    
    // MARK: - Initializer
    
    /// Initializes the `ArtistRepositoryImpl` with required dependencies.
    /// - Parameters:
    ///   - service: The service for network operations.
    ///   - artistMapper: The mapper for converting DTOs to domain models.
    ///   - errorMapper: The mapper for converting errors.
    ///   - dataStore: The data store for artist data.
    init(
        service: Service,
        artistMapper: ArtistMapper,
        errorMapper: ErrorMapper,
        dataStore: ArtistDataStore
    ) {
        self.service = service
        self.artistMapper = artistMapper
        self.errorMapper = errorMapper
        self.dataStore = dataStore
    }
    
    // MARK: - Public method
    
    /// Fetches an array of `Artist` objects based on the provided search query.
    /// - Parameter query: The search query used to find artists.
    /// - Returns: An array of `Artist` objects mapped from the search result.
    /// - Throws: An error if the network request fails or if mapping the result fails.
    func fetch(query: String) async throws -> [Artist] {
        
        // Fetch the search result DTO from the service
        let result = try await fetchArtistsResult(query: query)
        
        // Map the search result DTO to an array of Artist objects
        let artists = artistMapper.map(searchArtistsResultDTO: result)
        
        // Update the selection status of the fetched artists
        return updateSelectionStatus(for: artists)
    }
    
    /// Marks the specified artist as selected and saves the updated artist to the data store.
    /// - Parameter artist: The `Artist` object to be selected and saved.
    /// - Returns: The updated `Artist` object with the `isSelected` property set to true.
    func selectAndSave(artist: Artist) -> Artist {
        var updatedArtist = artist
        updatedArtist.isSelected = true
        
        // Save the updated artist to the data store
        return dataStore.saveArtist(artist: updatedArtist)
    }
    
    /// Marks the specified artist as unselected and removes it from the data store.
    /// - Parameter artist: The `Artist` object to be unselected and unregistered.
    /// - Returns: The updated `Artist` object with the `isSelected` property set to false.
    func deselectAndUnregister(artist: Artist) -> Artist {
        var updatedArtist = artist
        updatedArtist.isSelected = false
        
        // Remove the artist from the data store
        dataStore.removeArtist(id: updatedArtist.id)
        
        return updatedArtist
    }
    
    /// Retrieves an array of selected artists from the data store.
    /// - Returns: An array of `Artist` objects that have been saved and marked as selected.
    func fetchSelectedArtists() -> [Artist] {
        // Fetch and return currently selected artists from the data store
        dataStore.getSavedArtists()
    }
    
    /// Resets the list of selected artists in the data store.
    func resetSelectedArtists() {
        // Clear all selected artists from the data store
        dataStore.reset()
    }
    
    // MARK: - Private methods
    
    /// Fetches the search result DTO from the service.
    /// - Parameter query: The search query used to find artists.
    /// - Returns: The `SearchArtistsResultDTO` containing the fetched artist data.
    /// - Throws: An error if the network request fails.
    private func fetchArtistsResult(query: String) async throws -> SearchArtistsResultDTO {
        do {
            // Attempt to load the artist search result from the service
            return try await service.load(target: ArtistTarget.search(query: query))
        } catch let error as ServiceError {
            // Map service errors to user-friendly errors
            throw errorMapper.map(serviceError: error)
        }
    }
    
    /// Updates the selection status of fetched artists based on the saved artist IDs.
    /// - Parameter fetchedArtists: An array of `Artist` objects that need to be updated.
    /// - Returns: An array of `Artist` objects with the updated `isSelected` property based on whether
    ///            their IDs are found in the saved artist IDs.
    private func updateSelectionStatus(for fetchedArtists: [Artist]) -> [Artist] {
        
        // Get the set of saved artist IDs for quick lookup
        let savedArtistIds = Set(dataStore.getSavedArtistIds())
        
        // Map the fetched artists, updating their selection status
        return fetchedArtists.map { artist in
            var updatedArtist = artist
            updatedArtist.isSelected = savedArtistIds.contains(artist.id)
            
            return updatedArtist
        }
    }
    
}
