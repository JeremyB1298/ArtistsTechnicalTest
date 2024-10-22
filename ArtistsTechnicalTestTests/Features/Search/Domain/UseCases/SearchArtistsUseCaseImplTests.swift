//
//  SearchArtistsUseCaseImplTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 22/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

/// A test case class for testing the`SearchArtistsUseCaseImpl` implementation.
/// This class verifies that the search use case correctly handles query length rules.
final class SearchArtistsUseCaseImplTests: XCTestCase {

    // MARK: - Private property
    
    private var sut: SearchArtistsUseCase!
    
    // MARK: - Setup
    
    override func setUp() {
        let repository: ArtistRepository = MockArtistRepositoryImpl()
        sut = SearchArtistsUseCaseImpl(repository: repository)
        super.setUp()
    }
    
    // MARK: - TearDown
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Tests that the search returns an empty array for an empty query.
    func test_query_length_rule_with_empty_query() async {
        let query = ""
        
        let result = try? await sut.invoke(query: query)
        
        XCTAssertTrue(result!.isEmpty)
    }
    
    /// Tests that the search returns an empty array for a one-character query.
    func test_query_length_rule_with_one_character() async {
        let query = "M"
        
        let result = try? await sut.invoke(query: query)
        
        XCTAssertTrue(result!.isEmpty)
    }
    
    /// Tests that the search returns an empty array for a two-character query.
    func test_query_length_rule_with_two_character() async {
        let query = "Mo"
        
        let result = try? await sut.invoke(query: query)
        
        XCTAssertTrue(result!.isEmpty)
    }
    
    /// Tests that the search returns a non-empty array for a three-character query.
    func test_query_length_rule_with_three_character() async {
        let query = "Mon"
        
        let result = try? await sut.invoke(query: query)
        
        XCTAssertFalse(result!.isEmpty)
    }

}

// MARK: - Model

private final class MockArtistRepositoryImpl: ArtistRepository {
    func fetch(query: String) async throws -> [Artist] {
        [Artist(id: 0, title: "My ARtist", isSelected: true)]
    }
    
    func selectAndSave(artist: ArtistsTechnicalTest.Artist) -> Artist {
        Artist(id: 0, title: "My ARtist", isSelected: true)
    }
    
    func deselectAndUnregister(artist: ArtistsTechnicalTest.Artist) -> Artist {
        Artist(id: 0, title: "My ARtist", isSelected: false)
    }
    
    func fetchSelectedArtists() -> [ArtistsTechnicalTest.Artist] {
        []
    }
    
    func resetSelectedArtists() {}
    
}
