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
    
    private var sut: ArtistRepository!
    
    // MARK: - Setup
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        let service = ServiceImpl(session: urlSession)
        let artistMapper = ArtistMapper()
        let errorMapper = ErrorMapper()
        let dataStore: ArtistDataStore = ArtistDataStoreImpl()
        
        sut = ArtistRepositoryImpl(service: service, artistMapper: artistMapper, errorMapper: errorMapper, dataStore: dataStore)
        super.setUp()
    }
    
    // MARK: - TearDown
    
    override func tearDown() {
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
        
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try JSONEncoder().encode(expectedData)
            return (response, data)
        }
        
        do {
            let artists = try await sut.fetch(query: "")
            XCTAssertEqual(artists.count, 2)
            XCTAssertEqual(artists[0].id, 0)
            XCTAssertEqual(artists[0].title, "First artist")
            XCTAssertEqual(artists[1].id, 1)
            XCTAssertEqual(artists[1].title, "Second artist")
        } catch let error {
            XCTFail("Expected successful load, but got error: \(error)")
        }
        
    }
    
    /// Tests the fetch method when there is a decoding error.
    func test_fetch_with_decoding_error() async {
        let expectedData = MockDecodableType()
        
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try JSONEncoder().encode(expectedData)
            return (response, data)
        }
        
        do {
            _ = try await sut.fetch(query: "")
            XCTFail("Expected error, but got successful load")
        } catch let error as AppError {
            switch error {
            case .decodingError:
                break
            default:
                XCTFail("Expected decoding error, but got error: \(error)")
            }
        } catch let error {
            XCTFail("Expected AppError, but got error: \(error)")
        }
        
    }
    
    /// Tests the selectAndSave method to ensure an artist is marked as selected when saved.
    /// This test verifies that the returned artist has the correct ID, title, and isSelected property set to true.
    func test_select_and_save() {
        let artist = Artist(id: 0, title: "My artist", isSelected: false)
        
        let artistUpdated = sut.selectAndSave(artist: artist)
        
        XCTAssertEqual(artist.id, artistUpdated.id)
        XCTAssertEqual(artist.title, artistUpdated.title)
        XCTAssertTrue(artistUpdated.isSelected)
    }
    
    /// Tests the unselectAndUnregister method to ensure an artist is marked as unselected and removed from the data store.
    /// This test verifies that the returned artist has the correct ID, title, and isSelected property set to false.
    func test_unselect_and_unregister() {
        let artist = Artist(id: 0, title: "My artist", isSelected: true)
        
        let artistUpdated = sut.deselectAndUnregister(artist: artist)
        
        XCTAssertEqual(artist.id, artistUpdated.id)
        XCTAssertEqual(artist.title, artistUpdated.title)
        XCTAssertFalse(artistUpdated.isSelected)
    }
    
    /// Tests the fetchSelectedArtists method to ensure it returns artists that have been selected.
    /// This test verifies that the correct artists are returned from the data store.
    func test_fetch_selected_artists() {
        let artist1 = Artist(id: 0, title: "My artist", isSelected: false)
        let artist2 = Artist(id: 1, title: "My other artist", isSelected: false)
        
        _ = sut.selectAndSave(artist: artist1)
        _ = sut.selectAndSave(artist: artist2)
        
        let selectedArtists = sut.fetchSelectedArtists()
        
        XCTAssertEqual(selectedArtists[0].id, artist1.id)
        XCTAssertEqual(selectedArtists[0].title, artist1.title)
        XCTAssertEqual(selectedArtists[1].id, artist2.id)
        XCTAssertEqual(selectedArtists[1].title, artist2.title)
    }
    
}

// MARK: - Models

/// A private mock struct representing the response DTO for searching artists.
/// This struct conforms to `Codable` to facilitate encoding and decoding during tests.
private struct MockSearchArtistsResultDTO: Codable {
    let data: [MockArtisttDTO]
}

/// A private mock struct representing an individual artist DTO.
/// This struct conforms to `Codable` to facilitate encoding and decoding during tests.
private struct MockArtisttDTO: Codable {
    let id: Int
    let title: String
}
