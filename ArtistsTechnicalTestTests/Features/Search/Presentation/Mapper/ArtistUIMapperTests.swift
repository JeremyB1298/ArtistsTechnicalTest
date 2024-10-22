//
//  ArtistUIMapperTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 22/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

/// A test case class for tseting the `ArtistUIMapper`implementation.
/// This class verifies that the artist mapper correctly maps domain models to UI models and vice versa.
final class ArtistUIMapperTests: XCTestCase {

    // MARK: - Private property
    
    private var sut: ArtistUIMapper!
    
    // MARK: - Setup
    
    override func setUp() {
        sut = ArtistUIMapper()
        super.setUp()
    }
    
    // MARK: - TearDown
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Tests the mapping of a domain `Artist` object to a UI `ArtistUIModel` object.
    func test_map_artist_to_artist_ui_model() {
        let artist = Artist(id: 78, title: "My artist", isSelected: true)
        let uiArtist = sut.map(artist: artist)
        
        XCTAssertEqual(uiArtist.id, 78)
        XCTAssertEqual(uiArtist.title, "My artist")
        XCTAssertEqual(uiArtist.isSelected, true)
    }
    
    /// Tests the mapping of a UI `ArtistUIModel` object back to a domain `Artist` object.
    func test_map_artist_ui_model_to_artist() {
        let uiArtist = ArtistUIModel(id: 998, title: "My artist", isSelected: false)
        let artist = sut.map(artistUIModel: uiArtist)
        
        XCTAssertEqual(artist.id, 998)
        XCTAssertEqual(artist.title, "My artist")
        XCTAssertEqual(artist.isSelected, false)
    }

}
