//
//  ArtistRepository.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// A protocol defining the requirements for an artist repository.
/// This protocol provides methods for fetching and saving artist data.
protocol ArtistRepository {
    func fetch(query: String) async throws -> [Artist]
    func selectAndSave(artist: Artist) -> Artist
    func unselectAndUnregister(artist: Artist) -> Artist
    func fetchSelectedArtists() -> [Artist]
}
