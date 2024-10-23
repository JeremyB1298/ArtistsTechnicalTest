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
    
    /// The system under test (SUT), which is the instance of the `ArtistUIMapper` to be tested.
    private var sut: ArtistUIMapper!
    
    // MARK: - Setup
    
    /// Sets up the test environment before each test method is invoked.
    /// This method initializes the artist UI mapper instance.
    override func setUp() {
        
        // Initialize the SUT
        sut = ArtistUIMapper()
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
    
    /// Tests the mapping of a domain `Artist` object to a UI `ArtistUIModel` object.
    func test_map_artist_to_artist_ui_model() {
        
        // Create a domain artist instance
        let artist = Artist(id: 78, title: "My artist", isSelected: true)
        
        // Map to UI model
        let uiArtist = sut.map(artist: artist)
        
        // Verify the properties of the mapped UI model
        XCTAssertEqual(uiArtist.id, 78)
        XCTAssertEqual(uiArtist.title, "My artist")
        XCTAssertEqual(uiArtist.isSelected, true)
    }
    
    /// Tests the mapping of a UI `ArtistUIModel` object back to a domain `Artist` object.
    func test_map_artist_ui_model_to_artist() {
        
        // Create a UI artist instance
        let uiArtist = ArtistUIModel(id: 998, title: "My artist", isSelected: false)
        
        // Map to domain model
        let artist = sut.map(artistUIModel: uiArtist)
        
        // Verify the properties of the mapped domain artist
        XCTAssertEqual(artist.id, 998)
        XCTAssertEqual(artist.title, "My artist")
        XCTAssertEqual(artist.isSelected, false)
    }
    
}
