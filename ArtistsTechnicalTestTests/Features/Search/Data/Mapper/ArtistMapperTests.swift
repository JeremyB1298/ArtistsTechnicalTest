//
//  ArtistMapperTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 22/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

/// A test case class for testing the `ArtistMapper` implementation.
/// This class verifies that the artist mapper correctly maps DTOs to domain models.
final class ArtistMapperTests: XCTestCase {
    
    // MARK: - Private property
    
    /// The system under test (SUT), which is the instance of the `ArtistMapper` to be tested.
    private var sut: ArtistMapper!
    
    // MARK: - Setup
    
    /// Sets up the test environment before each test method is invoked.
    /// This method initializes the artist mapper instance.
    override func setUp() {
        
        // Initialize the SUT
        sut = ArtistMapper()
        super.setUp()
    }
    
    // MARK: - TearDown
    
    /// Cleans up the test environment after each test method is invoked.
    /// This method resets the SUT to nil.
    override func tearDown() {
        
        // Release the SUT
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Tests the mapping of `SearchArtistsResultDTO` into an array of `Artist` objects.
    func test_map_searchArtistsResultDTO_into_artist_array() {
        let searchArtistsResultDTO: SearchArtistsResultDTO = .init(
            data: [
                .init(
                    id: 0000,
                    title: "First artist"
                ),
                .init(
                    id: 1111,
                    title: "Second artist"
                ),
            ]
        )
        
        // Map the DTO to an array of artists
        let artists = sut.map(searchArtistsResultDTO: searchArtistsResultDTO)
        
        // Verify that the mapped artists match the expected values from the DTO
        XCTAssertEqual(artists[0].id, searchArtistsResultDTO.data[0].id)
        XCTAssertEqual(artists[0].title, searchArtistsResultDTO.data[0].title)
        XCTAssertEqual(artists[1].id, searchArtistsResultDTO.data[1].id)
        XCTAssertEqual(artists[1].title, searchArtistsResultDTO.data[1].title)
    }
    
}
