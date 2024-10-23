//
//  SearchArtistsUseCase.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

// MARK: - QueryValidator

/// A protocol defining the requirements for validating search queries.
protocol QueryValidator {
    /// Validates the search query.
    /// - Parameter query: The search query to validate.
    /// - Returns: A Boolean indicating whether the query is valid.
    func isValid(query: String) -> Bool
}

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
    
    /// The repository used for fetching artist data.
    private let repository: ArtistRepository
    
    // MARK: - Initializer
    
    /// Initializes the use case with a given artist repository.
    /// - Parameter repository: The `ArtistRepository` to fetch artist data.
    init(repository: ArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Public method
    
    /// Invokes a search for artists based on the provided query.
    /// - Parameter query: The search query to find artists.
    /// - Returns: An array of `Artist`objects matching the query.
    /// - Throws: An error if search fails.
    func invoke(query: String) async throws -> [Artist] {
        // Validate the query before proceeding with the search
        guard isValid(query: query) else {
            return []
        }
        
        // Fetch artists from the repository using the valid query
        return try await repository.fetch(query: query)
    }
    
}

// MARK: - QueryValidator

extension SearchArtistsUseCaseImpl: QueryValidator {
    
    /// Validates the search query.
    /// - Parameter query: The search query to validate.
    /// - Returns: A Boolean indicating whether the query is valid.
    func isValid(query: String) -> Bool {
        
        // A query is considered valid if its length is 3 characters or more
        return query.count >= 3
    }
    
}
