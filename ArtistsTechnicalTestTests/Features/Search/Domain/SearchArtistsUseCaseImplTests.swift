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
    
    private var sut: SearchArtistsUseCaseImpl!
    
    // MARK: - Setup
    
    override func setUp() {
        let repository: ArtistRepository = MockArtistRepositoryImpl()
        sut = SearchArtistsUseCaseImpl(repository: repository)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_invoke_with_invalid_query() async {
        let query = "Mo"
        
        do {
            let result = try await sut.invoke(query: query)
            XCTAssertTrue(result.isEmpty)
        } catch let error {
            XCTFail("Expected successful search, but received error: \(error)")
        }
    }
    
    func test_invoke_with_valid_query() async {
        let query = "My Artist"
        
        do {
            let result = try await sut.invoke(query: query)
            XCTAssertFalse(result.isEmpty)
        } catch let error {
            XCTFail("Expected successful search, but received error: \(error)")
        }
    }

}
