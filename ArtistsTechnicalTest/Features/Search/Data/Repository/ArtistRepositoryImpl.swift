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
    
    // MARK: - Initializer
    
    init(
        service: Service,
        artistMapper: ArtistMapper,
        errorMapper: ErrorMapper
    ) {
        self.service = service
        self.artistMapper = artistMapper
        self.errorMapper = errorMapper
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
        
        return artistMapper.map(searchArtistsResultDTO: result)
    }
    
}
