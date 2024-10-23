//
//  ArtistRepositoryImplTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

/// A test case class for testing the `ArtistRepositoryImpl` implementation of the `ArtistRepository` protocol.
/// This class verifies that the artist repository correctly handles fetching artist data and mapping it to domain models.
final class ArtistRepositoryImplTests: XCTestCase {
    
    // MARK: - Private property
    
    /// The system under test (SUT), which is the instance of the `ArtistRepository` to be tested.
    private var sut: ArtistRepository!
    
    // MARK: - Setup
    
    /// Sets up the test environment before each test method is invoked.
    /// This method configures a mock URL session and initializes the repository with it.
    override func setUp() {
        
        // Use an ephemeral configuration for testing
        let configuration = URLSessionConfiguration.ephemeral
        
        // Set the mock protocol for intercepting network requests
        configuration.protocolClasses = [MockURLProtocol.self]
        
        // Create a new URL session with the configuration
        let urlSession = URLSession(configuration: configuration)
        
        // Initialize the service with the mock session
        let service = ServiceImpl(session: urlSession)
        
        // Create an instance of the artist mapper
        let artistMapper = ArtistMapper()
        
        // Create an instance of the error mapper
        let errorMapper = ErrorMapper()
        
        // Create an instance of the data store
        let dataStore: ArtistDataStore = ArtistDataStoreImpl()
        
        // Initialize the repository
        sut = ArtistRepositoryImpl(service: service, artistMapper: artistMapper, errorMapper: errorMapper, dataStore: dataStore)
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
    
    /// Tests the fetch method when valid artist data is returned.
    func test_fetch_with_valid_result() async {
        let expectedData = MockSearchArtistsResultDTO(
            data: [
                .init(
                    id: 0,
                    title: "First artist"
                ),
                .init(
                    id: 1,
                    title: "Second artist"
                )
            ]
        )
        
        // Define the request handler for the mock URL protocol
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            
            // Create a mock response
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            // Encode the expected data to JSON
            let data = try JSONEncoder().encode(expectedData)
            
            // Return the response and data
            
            return (response, data)
        }
        
        do {
            
            // Attempt to load data from the repository
            let artists = try await sut.fetch(query: "")
            
            // Verify the count of returned artists
            XCTAssertEqual(artists.count, 2)
            
            // Verify the ID of the first artist
            XCTAssertEqual(artists[0].id, 0)
            
            // Verify the title of the first artist
            XCTAssertEqual(artists[0].title, "First artist")
            
            // Verify the ID of the second artist
            XCTAssertEqual(artists[1].id, 1)
            
            // Verify the title of the second artist
            XCTAssertEqual(artists[1].title, "Second artist")
        } catch let error {
            
            // Fail the test if an error occurs
            XCTFail("Expected successful load, but got error: \(error)")
        }
        
    }
    
    /// Tests the fetch method when there is a decoding error.
    func test_fetch_with_decoding_error() async {
        
        // Create a mock type for expected data
        let expectedData = MockDecodableType()
        
        // Define the request handler for the mock URL protocol
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            
            // Create a mock response
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            // Encode the expected data to JSON
            let data = try JSONEncoder().encode(expectedData)
            
            // Return the response and data
            return (response, data)
        }
        
        do {
            
            // Attempt to load data from the repository
            _ = try await sut.fetch(query: "")
            
            // Fail the test if no error occurs
            XCTFail("Expected error, but got successful load")
        } catch let error as AppError {
            switch error {
            case .decodingError:
                
                // Pass the test if decoding error occurs
                break
            default:
                
                // Fail the test for unexpected errors
                XCTFail("Expected decoding error, but got error: \(error)")
            }
        } catch let error {
            
            // Fail the test for unexpected errors
            XCTFail("Expected AppError, but got error: \(error)")
        }
        
    }
    
    /// Tests the selectAndSave method to ensure an artist is marked as selected when saved.
    /// This test verifies that the returned artist has the correct ID, title, and isSelected property set to true.
    func test_select_and_save() {
        
        // Create an artist instance
        let artist = Artist(id: 0, title: "My artist", isSelected: false)
        
        // Save the artist
        let artistUpdated = sut.selectAndSave(artist: artist)
        
        // Verify the ID of the updated artist
        XCTAssertEqual(artist.id, artistUpdated.id)
        
        // Verify the title of the updated artist
        XCTAssertEqual(artist.title, artistUpdated.title)
        
        // Verify that the updated artist is selected
        XCTAssertTrue(artistUpdated.isSelected)
    }
    
    /// Tests the unselectAndUnregister method to ensure an artist is marked as unselected and removed from the data store.
    /// This test verifies that the returned artist has the correct ID, title, and isSelected property set to false.
    func test_unselect_and_unregister() {
        
        // Create a selected artist instance
        let artist = Artist(id: 0, title: "My artist", isSelected: true)
        
        // Deselect and unregister the artist
        let artistUpdated = sut.deselectAndUnregister(artist: artist)
        
        // Verify the ID of the updated artist
        XCTAssertEqual(artist.id, artistUpdated.id)
        
        // Verify the title of the updated artist
        XCTAssertEqual(artist.title, artistUpdated.title)
        
        // Verify that the updated artist is not selected
        XCTAssertFalse(artistUpdated.isSelected)
    }
    
    /// Tests the fetchSelectedArtists method to ensure it returns artists that have been selected.
    /// This test verifies that the correct artists are returned from the data store.
    func test_fetch_selected_artists() {
        
        // Create first artist instance
        let artist1 = Artist(id: 0, title: "My artist", isSelected: false)
        
        // Create second artist instance
        let artist2 = Artist(id: 1, title: "My other artist", isSelected: false)
        
        // Save the first artist
        _ = sut.selectAndSave(artist: artist1)
        
        // Save the second artist
        _ = sut.selectAndSave(artist: artist2)
        
        // Fetch selected artists
        let selectedArtists = sut.fetchSelectedArtists()
        
        // Verify the ID of the first selected artist
        XCTAssertEqual(selectedArtists[0].id, artist1.id)
        
        // Verify the title of the first selected artist
        XCTAssertEqual(selectedArtists[0].title, artist1.title)
        
        // Verify the ID of the second selected artist
        XCTAssertEqual(selectedArtists[1].id, artist2.id)
        
        // Verify the title of the second selected artist
        XCTAssertEqual(selectedArtists[1].title, artist2.title)
    }
    
    /// Tests the resetSelectedArtists method to ensure all artists are removed.
    func test_reset_selected_artists() {
        
        // Create an artist instance
        let artist = Artist(id: 0, title: "My artist", isSelected: false)
        
        // Save the artist
        _ = sut.selectAndSave(artist: artist)
        
        // Reset selected artists
        sut.resetSelectedArtists()
        
        // Fetch selected artists
        let selectedArtists = sut.fetchSelectedArtists()
        
        // Verify that no artists are returned
        XCTAssertTrue(selectedArtists.isEmpty)
    }
    
}

// MARK: - Models

/// A private mock struct representing the response DTO for searching artists.
/// This struct conforms to `Codable` to facilitate encoding and decoding during tests.
private struct MockSearchArtistsResultDTO: Codable {
    
    // An array of mock artist DTOs
    let data: [MockArtisttDTO]
}

/// A private mock struct representing an individual artist DTO.
/// This struct conforms to `Codable` to facilitate encoding and decoding during tests.
private struct MockArtisttDTO: Codable {
    
    // The ID of the artist
    let id: Int
    
    // The title of the artist
    let title: String
}
