//
//  ArtistDataStoreImplTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

/// A test case class for testing the `ArtistDataStoreImpl` implementation of the `ArtistDataStore` protocol.
/// This class verifies that the artist data store correctly handles saving, removing, and retrieving artist information.
final class ArtistDataStoreImplTests: XCTestCase {
    
    // MARK: - Private property
    
    /// The system under test (SUT), which is the instance of the `ArtistDataStore` to be tested.
    private var sut: ArtistDataStoreImpl!
    
    // MARK: - Setup
    
    /// Sets up the test environment before each test method is invoked.
    /// This method initializes the artist data store instance.
    override func setUp() {
        
        // Initialize the SUT
        sut = ArtistDataStoreImpl()
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
    
    /// Tests the save functionality of the artist data store.
    /// Verifies that saved artists are correctly stored and retrievable.
    func test_save_an_artist() {
        sut = ArtistDataStoreImpl()
        
        // Create first artist instance
        let artist1 = Artist(id: 0, title: "My artist to save 1", isSelected: false)
        
        // Create second artist instance
        let artist2 = Artist(id: 1, title: "My artist to save 2", isSelected: true)
        
        // Save the first artist
        _ = sut.saveArtist(artist: artist1)
        
        // Save the second artist
        _ = sut.saveArtist(artist: artist2)
        
        // Retrieve saved artists
        let artistsSaved = sut.getSavedArtists()
        
        // Verify the saved artists
        
        XCTAssertEqual(artistsSaved[0].id, artist1.id)
        XCTAssertEqual(artistsSaved[0].title, artist1.title)
        XCTAssertEqual(artistsSaved[0].isSelected, artist1.isSelected)
        XCTAssertEqual(artistsSaved[1].id, artist2.id)
        XCTAssertEqual(artistsSaved[1].title, artist2.title)
        XCTAssertEqual(artistsSaved[1].isSelected, artist2.isSelected)
    }
    
    /// Tests the remove functionality of the artist data store.
    /// Verifies that an artist can be removed by its identifier.
    func test_remove_an_artist() {
        sut = ArtistDataStoreImpl()
        
        // Create first artist instance
        let artist1 = Artist(id: 0, title: "My artist to save 1", isSelected: false)
        
        // Create second artist instance
        let artist2 = Artist(id: 1, title: "My artist to save 2", isSelected: true)
        
        // Save the first artist
        _ = sut.saveArtist(artist: artist1)
        
        // Save the second artist
        _ = sut.saveArtist(artist: artist2)
        
        // Remove the first artist by ID
        sut.removeArtist(id: artist1.id)
        
        // Retrieve saved artists
        let artistsSaved = sut.getSavedArtists()
        
        // Verify the remaining saved artist
        XCTAssertEqual(artistsSaved[0].id, artist2.id)
        XCTAssertEqual(artistsSaved[0].title, artist2.title)
        XCTAssertEqual(artistsSaved[0].isSelected, artist2.isSelected)
    }
    
    /// Tests the retrieval of artist IDs from the data store.
    /// Verifies that the correct IDs are returned for saved artists.
    func test_get_artist_ids() {
        sut = ArtistDataStoreImpl()
        
        // Create first artist instance
        let artist1 = Artist(id: 0, title: "My artist to save 1", isSelected: false)
        
        // Create second artist instance
        let artist2 = Artist(id: 1, title: "My artist to save 2", isSelected: true)
        
        // Save the first artist
        _ = sut.saveArtist(artist: artist1)
        
        // Save the second artist
        _ = sut.saveArtist(artist: artist2)
        
        // Retrieve saved artist IDs
        let artistIdsSaved = sut.getSavedArtistIds()
        
        // Verify the saved artist IDs
        XCTAssertEqual(artistIdsSaved, [artist1.id, artist2.id])
    }
    
    /// Tests the retrieve of all saved artists.
    func test_get_saved_artists() {
        sut = ArtistDataStoreImpl()
        
        // Create first artist instance
        let artist1 = Artist(id: 0, title: "My artist to save 1", isSelected: false)
        
        // Create second artist instance
        let artist2 = Artist(id: 1, title: "My artist to save 2", isSelected: true)
        
        // Save the first artist
        _ = sut.saveArtist(artist: artist1)
        
        // Save the second artist
        _ = sut.saveArtist(artist: artist2)
        
        // Retrieve saved artists
        let artistsSaved = sut.getSavedArtists()
        
        // Verify the saved artists
        XCTAssertEqual(artistsSaved[0].id, artist1.id)
        XCTAssertEqual(artistsSaved[0].title, artist1.title)
        XCTAssertEqual(artistsSaved[0].isSelected, artist1.isSelected)
        XCTAssertEqual(artistsSaved[1].id, artist2.id)
        XCTAssertEqual(artistsSaved[1].title, artist2.title)
        XCTAssertEqual(artistsSaved[1].isSelected, artist2.isSelected)
    }
    
    /// Tests the reset functionality of the data store
    func test_reset() {
        sut = ArtistDataStoreImpl()
        
        // Create first artist instance
        let artist1 = Artist(id: 0, title: "My artist to save 1", isSelected: false)
        
        // Create second artist instance
        let artist2 = Artist(id: 1, title: "My artist to save 2", isSelected: true)
        
        // Save the first artist
        _ = sut.saveArtist(artist: artist1)
        
        // Save the second artist
        _ = sut.saveArtist(artist: artist2)
        
        // Reset the data store
        sut.reset()
        
        // Retrieve saved artists
        let artistsSaved = sut.getSavedArtists()
        
        // Verify that no artists are returned
        XCTAssertTrue(artistsSaved.isEmpty)
    }
    
}
