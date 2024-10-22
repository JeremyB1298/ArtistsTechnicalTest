//
//  SearchArtistsUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - SearchArtistsUseCase

/// A protocol defining the requirements for searching artists.
/// This protocol provides a method for invoking artist searches with a query.
protocol SearchArtistsUseCase {
    /// Invokes a search for artists based on the provided query.
    /// - Parameter query: The search query to find artists.
    /// - Returns: An array of `Artist`objects matching the query.
    /// - Throws: An error if search fails.
    func invoke(query: String) async throws -> [Artist]
}

// MARK: - SearchArtistsUseCaseImpl

/// A final implementation of the `SearchArtistUseCase`protocol.
/// This class uses an `ArtistRepository`to fetch artist data based on a search query.
final class SearchArtistsUseCaseImpl: SearchArtistsUseCase {
    
    // MARK: - Private property
    
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    /// Invokes a search for artists based on the provided query.
    /// - Parameter query: The search query to find artists.
    /// - Returns: An array of `Artist`objects matching the query.
    /// - Throws: An error if search fails.
    func invoke(query: String) async throws -> [Artist] {
        guard query.count > 2 else {
            return []
        }
        return try await repository.fetch(query: query)
    }
    
}
