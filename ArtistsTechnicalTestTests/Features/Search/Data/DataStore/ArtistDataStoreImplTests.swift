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
    
    private var sut: ArtistDataStoreImpl!
    
    // MARK: - Setup
    
    override func setUp() {
        sut = ArtistDataStoreImpl()
        super.setUp()
    }
    
    // MARK: - TearDown
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Tests the save functionality of the artist data store.
    /// Verifies that saved artists are correctly stored and retrievable.
    func test_save_an_artist() {
        sut = ArtistDataStoreImpl()
        let artist1 = Artist(id: 0, title: "My artist to save 1", isSelected: false)
        let artist2 = Artist(id: 1, title: "My artist to save 2", isSelected: true)
        
        _ = sut.saveArtist(artist: artist1)
        _ = sut.saveArtist(artist: artist2)
        
        let artistsSaved = sut.getSavedArtists()
        
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
        let artist1 = Artist(id: 0, title: "My artist to save 1", isSelected: false)
        let artist2 = Artist(id: 1, title: "My artist to save 2", isSelected: true)
        
        _ = sut.saveArtist(artist: artist1)
        _ = sut.saveArtist(artist: artist2)
        
        sut.removeArtist(id: artist1.id)
        
        let artistsSaved = sut.getSavedArtists()
        
        XCTAssertEqual(artistsSaved[0].id, artist2.id)
        XCTAssertEqual(artistsSaved[0].title, artist2.title)
        XCTAssertEqual(artistsSaved[0].isSelected, artist2.isSelected)
    }
    
    /// Tests the retrieval of artist IDs from the data store.
    /// Verifies that the correct IDs are returned for saved artists.
    func test_get_artist_ids() {
        sut = ArtistDataStoreImpl()
        let artist1 = Artist(id: 0, title: "My artist to save 1", isSelected: false)
        let artist2 = Artist(id: 1, title: "My artist to save 2", isSelected: true)
        
        _ = sut.saveArtist(artist: artist1)
        _ = sut.saveArtist(artist: artist2)
        
        let artistIdsSaved = sut.getSavedArtistIds()
        
        XCTAssertEqual(artistIdsSaved, [artist1.id, artist2.id])
    }
    
    /// Tests the retrieve of all saved artists.
    func test_get_saved_artists() {
        sut = ArtistDataStoreImpl()
        let artist1 = Artist(id: 0, title: "My artist to save 1", isSelected: false)
        let artist2 = Artist(id: 1, title: "My artist to save 2", isSelected: true)
        
        _ = sut.saveArtist(artist: artist1)
        _ = sut.saveArtist(artist: artist2)
        
        let artistsSaved = sut.getSavedArtists()
        
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
        let artist1 = Artist(id: 0, title: "My artist to save 1", isSelected: false)
        let artist2 = Artist(id: 1, title: "My artist to save 2", isSelected: true)
        
        _ = sut.saveArtist(artist: artist1)
        _ = sut.saveArtist(artist: artist2)
        
        sut.reset()
        
        let artistsSaved = sut.getSavedArtists()
        
        XCTAssertTrue(artistsSaved.isEmpty)
    }
    
}
