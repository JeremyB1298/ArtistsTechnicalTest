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
    
    private let service: Service
    private let artistMapper: ArtistMapper
    private let errorMapper: ErrorMapper
    private let dataStore: ArtistDataStore
    
    // MARK: - Initializer
    
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
        let result: SearchArtistsResultDTO
        do {
            result = try await service.load(target: ArtistTarget.search(query: query))
        } catch let error as ServiceError {
            throw errorMapper.map(serviceError: error)
        }
        
        let artists = artistMapper.map(searchArtistsResultDTO: result)
        
        return updateSelectionStatus(for: artists)
    }
    
    /// Marks the specified artist as selected and saves the updated artist to the data store.
    /// - Parameter artist: The `Artist` object to be selected and saved.
    /// - Returns: The updated `Artist` object with the `isSelected` property set to true.
    func selectAndSave(artist: Artist) -> Artist {
        var updatedArtist = artist
        updatedArtist.isSelected = true
        
        return dataStore.saveArtist(artist: updatedArtist)
    }
    
    /// Marks the specified artist as unselected and removes it from the data store.
    /// - Parameter artist: The `Artist` object to be unselected and unregistered.
    /// - Returns: The updated `Artist` object with the `isSelected` property set to false.
    func deselectAndUnregister(artist: Artist) -> Artist {
        var updatedArtist = artist
        updatedArtist.isSelected = false
        dataStore.removeArtist(id: updatedArtist.id)
        return updatedArtist
    }
    
    /// Retrieves an array of selected artists from the data store.
    /// - Returns: An array of `Artist` objects that have been saved and marked as selected.
    func fetchSelectedArtists() -> [Artist] {
        dataStore.getSavedArtists()
    }
    
    func resetSelectedArtists() {
        dataStore.reset()
    }
    
    // MARK: - Private method
    
    /// Updates the selection status of fetched artists based on the saved artist IDs.
    /// - Parameter fetchedArtists: An array of `Artist` objects that need to be updated.
    /// - Returns: An array of `Artist` objects with the updated `isSelected` property based on whether
    ///            their IDs are found in the saved artist IDs.
    private func updateSelectionStatus(for fetchedArtists: [Artist]) -> [Artist] {
        let savedArtistIds = Set(dataStore.getSavedArtistIds())
        
        return fetchedArtists.map { artist in
            var updatedArtist = artist
            updatedArtist.isSelected = savedArtistIds.contains(artist.id)
            return updatedArtist
        }
    }
    
}
