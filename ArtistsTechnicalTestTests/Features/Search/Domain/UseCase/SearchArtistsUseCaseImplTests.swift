//
//  SearchArtistsUseCaseImplTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 23/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

final class SearchArtistsUseCaseImplTests: XCTestCase {
    
    // MARK: - Private property
    
    /// The system under test (SUT), which is the instance of the `SearchArtistsUseCaseImpl` to be tested.
    private var sut: SearchArtistsUseCaseImpl!
    
    // MARK: - Setup
    
    /// Sets up the test environment before each test method is invoked.
    /// This method initializes the search use case with a mock repository.
    override func setUp() {
        
        // Use a mock repository for testing
        let repository: ArtistRepository = MockArtistRepositoryImpl()
        
        // Initialize the SUT
        sut = SearchArtistsUseCaseImpl(repository: repository)
        super.setUp()
    }
    
    /// Cleans up the test environment after each test method is invoked.
    /// This method resets the SUT to nil.
    override func tearDown() {
        
        // Release the SUT
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Tests the invoke method with an invalid query.
    func test_invoke_with_invalid_query() async {
        
        // Define a short query that is invalid
        let query = "Mo"
        
        do {
            
            // Attempt to search with the invalid query
            let result = try await sut.invoke(query: query)
            
            // Verify that the result is empty
            XCTAssertTrue(result.isEmpty)
        } catch let error {
            
            // Fail the test if an error occurs
            XCTFail("Expected successful search, but received error: \(error)")
        }
    }
    
    /// Tests the invoke method with a valid query.
    func test_invoke_with_valid_query() async {
        
        // Define a valid query
        let query = "My Artist"
        
        do {
            
            // Attempt to search with the valid query
            let result = try await sut.invoke(query: query)
            
            // Verify that the result is not empty
            XCTAssertFalse(result.isEmpty)
        } catch let error {
            
            // Fail the test if an error occurs
            XCTFail("Expected successful search, but received error: \(error)")
        }
    }
    
}
