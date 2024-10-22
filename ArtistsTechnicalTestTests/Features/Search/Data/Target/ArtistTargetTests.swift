//
//  ArtistTargetTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 22/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

/// A test case class for testing the `ArtistTarget` enumeration.
/// This class verifies that the target correctly generates URLs for artist-related API requests.
final class ArtistTargetTests: XCTestCase {
    
    // MARK: - Tests
    
    /// Tests that the base URL is correct for the `ArtistTarget`
    func test_base_url() {
        let target = ArtistTarget.search(query: "Artist")
        XCTAssertEqual(target.baseURL, "https://api.artic.edu")
    }
    
    /// Tests that the path is correctly generated for the search case with a simple query.
    func test_path_with_simple_query() {
        let query = "Pablo Pi"
        let target = ArtistTarget.search(query: query)
        XCTAssertEqual(target.path, "/api/v1/artists/search?q=Pablo%20Pi")
    }
    
    /// Tests that the path is correctly generated for the search case with special characters.
    func test_path_with_special_characters() {
        let query = "Pablo & Picasso"
        let target = ArtistTarget.search(query: query)
        XCTAssertEqual(target.path, "/api/v1/artists/search?q=Pablo%20&%20Picasso")
    }
    
    /// Tests that the path is correctly generated for the search case with an empty query.
    func testPathWithEmptyQuery() {
        let query = ""
        let target = ArtistTarget.search(query: query)
        XCTAssertEqual(target.path, "/api/v1/artists/search?q=")
    }
    
    /// Tests that the path is correctly generated for a query with spaces.
    func testPathWithSpacesInQuery() {
        let query = "   "
        let target = ArtistTarget.search(query: query)
        XCTAssertEqual(target.path, "/api/v1/artists/search?q=%20%20%20")
    }
    
}
