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
        guard isValid(query: query) else {
            return []
        }
        return try await repository.fetch(query: query)
    }
    
}

// MARK: - QueryValidator

extension SearchArtistsUseCaseImpl: QueryValidator {
    
    /// Validates the search query.
    /// - Parameter query: The search query to validate.
    /// - Returns: A Boolean indicating whether the query is valid.
    func isValid(query: String) -> Bool {
        return query.count >= 3
    }
    
}
