//
//  MockArtistRepositoryImpl.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 23/10/2024.
//

@testable import ArtistsTechnicalTest

/// A mock implementation of the `ArtistRepository` for testing purposes.
/// This class simulates the behavior of the real repository without making actual network calls.
final class MockArtistRepositoryImpl: ArtistRepository {
    
    func fetch(query: String) async throws -> [Artist] {
        return query == "My Artist" ? [Artist(id: 0, title: "My Artist", isSelected: false)] : []
    }
    
    func selectAndSave(artist: Artist) -> Artist {
        return Artist(id: artist.id, title: artist.title, isSelected: true)
    }
    
    func deselectAndUnregister(artist: Artist) -> Artist {
        return Artist(id: artist.id, title: artist.title, isSelected: false)
    }
    
    func fetchSelectedArtists() -> [Artist] {
        return []
    }
    
    func resetSelectedArtists() {}
    
}
