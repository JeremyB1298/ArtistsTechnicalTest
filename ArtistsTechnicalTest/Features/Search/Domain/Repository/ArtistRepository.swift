//
//  ArtistRepository.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// A protocol defining the requirements for an artist repository.
/// This protocol provides a method for fetching artist data based on a search query.
protocol ArtistRepository {
    func fetch(query: String) async throws -> [Artist]
}
