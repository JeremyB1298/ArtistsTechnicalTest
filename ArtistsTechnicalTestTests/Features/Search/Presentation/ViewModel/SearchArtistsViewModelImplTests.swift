//
//  SearchArtistsViewModelImplTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 22/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

/// MARK: - A test case class for testing the `SearchArtistsViewModelImpl` implementation of the `SearchArtistsViewModel` protocol.
/// This class verifies that the view model correctly handles the search and selection of artists.
final class SearchArtistsViewModelImplTests: XCTestCase {
    
    // MARK: - Private property
    
    private var sut: SearchArtistsViewModelImpl!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        let repository: ArtistRepository = MockArtistRepositoryImpl()
        let mapper = ArtistUIMapper()
        sut = SearchArtistsViewModelImpl(
            searchArtistsUseCase: SearchArtistsUseCaseImpl(repository: repository),
            mapper: mapper,
            selectArtistUseCase: SelectArtistUseCaseImpl(repository: repository),
            deselectArtistUseCase: DeselectArtistUseCaseImpl(repository: repository),
            fetchSelectedArtistsUseCase: FetchSelectedArtistsUseCaseImpl(repository: repository),
            resetSelectedArtistsUseCase: ResetSelectedArtistsUseCaseImpl(repository: repository)
        )
    }
    
    // MARK: - TearDown
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Tests the search functionality with an empty query string.
    /// It verifies that the result is empty.
    func test_search_with_empty_query() async {
        let expectation = expectation(description: "Completion handler invoked")
        
        sut.search(query: "") { result in
            switch result {
            case .success:
                XCTAssertTrue(self.sut.uiArtists.isEmpty)
            case .failure:
                XCTFail("Expected success, but got an error.")
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    /// Tests the search functionality with a short query string (less than 3 characters).
    /// It verifies that the result is empty.
    func test_search_with_short_query() async {
        let expectation = expectation(description: "Completion handler invoked")
        
        sut.search(query: "A") { result in
            switch result {
            case .success:
                XCTAssertTrue(self.sut.uiArtists.isEmpty)
            case .failure:
                XCTFail("Expected success, but got an error.")
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    /// Tests the search functionality with a valid query string.
    /// It verifies that the result contains the expected artist.
    func test_search_with_valid_query() async {
        let expectation = expectation(description: "Completion handler invoked")
        
        sut.search(query: "My Artist") { result in
            switch result {
            case .success:
                XCTAssertFalse(self.sut.uiArtists.isEmpty)
                XCTAssertEqual(self.sut.uiArtists.count, 1)
                XCTAssertEqual(self.sut.uiArtists.first?.title, "My Artist")
            case .failure:
                XCTFail("Expected success, but got an error.")
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    /// Tests the update selection status functionality.
    /// It verifies that the artist's selection status is correctly updated.
    func test_updateSelectStatus() async {
        let expectation = expectation(description: "Completion handler invoked")
        let artist = Artist(id: 0, title: "My Artist", isSelected: false)
        sut.search(query: "My Artist") { result in
            self.sut.updateSelectStatus(for: artist.id, with: true)
            
            XCTAssertTrue(self.sut.uiArtists.first(where: { $0.id == artist.id })?.isSelected ?? false)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    /// Tests the functionality to switch between search states.
    /// It verifies that the state toggles correctly.
    func test_switchSearchState() {
        sut.switchSearchState()
        
        XCTAssertEqual(sut.searchState, .selected)
        
        sut.switchSearchState()
        
        XCTAssertEqual(sut.searchState, .results)
    }
    
    /// Tests the reset functionality.
    /// It verifies that the search state is reset to results and the artist list is empty.
    func test_reset() {
        sut.reset()
        
        XCTAssertEqual(sut.searchState, .results)
        XCTAssertTrue(sut.uiArtists.isEmpty)
    }
    
}

// MARK: - Models

/// A mock implementation of the `ArtistRepository` for testing purposes.
/// This class simulates the behavior of the real repository without making actual network calls.
private final class MockArtistRepositoryImpl: ArtistRepository {
    
    func fetch(query: String) async throws -> [Artist] {
        return query == "My Artist" ? [Artist(id: 0, title: "My Artist", isSelected: false)] : []
    }
    
    func selectAndSave(artist: Artist) -> Artist {
        return Artist(id: artist.id, title: artist.title, isSelected: true)
    }
    
    func deselectAndUnregister(artist: Artist) -> Artist {
        return Artist(id: artist.id, title: artist.title, isSelected: false)
    }
    
    func fetchSelectedArtists() -> [Artist] {
        return []
    }
    
    func resetSelectedArtists() {}
    
}
