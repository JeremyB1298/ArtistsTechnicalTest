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
    
    private var sut: ArtistMapper!
    
    // MARK: - Setup
    
    override func setUp() {
        sut = ArtistMapper()
        super.setUp()
    }
    
    // MARK: - TearDown
    
    override func tearDown() {
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
        
        let artists = sut.map(searchArtistsResultDTO: searchArtistsResultDTO)
        
        XCTAssertEqual(artists[0].id, searchArtistsResultDTO.data[0].id)
        XCTAssertEqual(artists[0].title, searchArtistsResultDTO.data[0].title)
        XCTAssertEqual(artists[1].id, searchArtistsResultDTO.data[1].id)
        XCTAssertEqual(artists[1].title, searchArtistsResultDTO.data[1].title)
    }

}
