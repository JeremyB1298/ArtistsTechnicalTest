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
    
    /// The system under test (SUT), which is the instance of the `SearchArtistsViewModelImpl` to be tested.
    private var sut: SearchArtistsViewModelImpl!
    
    // MARK: - Setup
    
    /// Sets up the test environment before each test method is invoked.
    /// This method initializes the search view model with a mock repository and mapper.
    override func setUp() {
        
        // Use a mock repository for testing
        let repository: ArtistRepository = MockArtistRepositoryImpl()
        
        // Initialize the UI mapper
        let mapper = ArtistUIMapper()
        
        // Initialize the searchArtistsUseCase
        let searchArtistsUseCase = SearchArtistsUseCaseImpl(repository: repository)
        
        // Initialize the selectArtistUseCase
        let selectArtistUseCase = SelectArtistUseCaseImpl(repository: repository)
        
        // Initialize the deselectArtistUseCase
        let deselectArtistUseCase = DeselectArtistUseCaseImpl(repository: repository)
        
        // Initialize the fetchSelectedArtistsUseCase
        let fetchSelectedArtistsUseCase = FetchSelectedArtistsUseCaseImpl(repository: repository)
        
        // Initialize the resetSelectedArtistsUseCase
        let resetSelectedArtistsUseCase = ResetSelectedArtistsUseCaseImpl(repository: repository)
        
        // Initialize the SUT
        sut = SearchArtistsViewModelImpl(
            searchArtistsUseCase: searchArtistsUseCase,
            mapper: mapper,
            selectArtistUseCase: selectArtistUseCase,
            deselectArtistUseCase: deselectArtistUseCase,
            fetchSelectedArtistsUseCase: fetchSelectedArtistsUseCase,
            resetSelectedArtistsUseCase: resetSelectedArtistsUseCase
        )
        
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
    
    /// Tests the search functionality with an empty query string.
    /// It verifies that the result is empty.
    func test_search_with_empty_query() async {
        
        // Create an expectation
        let expectation = expectation(description: "Completion handler invoked")
        
        sut.search(query: "") { result in
            switch result {
            case .success:
                
                // Verify that the artist list is empty
                XCTAssertTrue(self.sut.uiArtists.isEmpty)
            case .failure:
                
                // Fail if there is an error
                XCTFail("Expected success, but got an error.")
            }
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    /// Tests the search functionality with a short query string (less than 3 characters).
    /// It verifies that the result is empty.
    func test_search_with_short_query() async {
        
        // Create an expectation
        let expectation = expectation(description: "Completion handler invoked")
        
        sut.search(query: "A") { result in
            switch result {
            case .success:
                
                // Verify that the artist list is empty
                XCTAssertTrue(self.sut.uiArtists.isEmpty)
            case .failure:
                
                // Fail if there is an error
                XCTFail("Expected success, but got an error.")
            }
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    /// Tests the search functionality with a valid query string.
    /// It verifies that the result contains the expected artist.
    func test_search_with_valid_query() async {
        
        // Create an expectation
        let expectation = expectation(description: "Completion handler invoked")
        
        sut.search(query: "My Artist") { result in
            switch result {
            case .success:
                
                // Verify that the artist list is not empty
                XCTAssertFalse(self.sut.uiArtists.isEmpty)
                
                // Verify that one artist is returned
                XCTAssertEqual(self.sut.uiArtists.count, 1)
                
                // Verify the artist's title
                XCTAssertEqual(self.sut.uiArtists.first?.title, "My Artist")
            case .failure:
                
                // Fail if there is an error
                XCTFail("Expected success, but got an error.")
            }
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    /// Tests the update selection status functionality.
    /// It verifies that the artist's selection status is correctly updated.
    func test_updateSelectStatus() async {
        
        // Create an expectation
        let expectation = expectation(description: "Completion handler invoked")
        
        // Create an artist instance
        let artist = Artist(id: 0, title: "My Artist", isSelected: false)
        
        sut.search(query: "My Artist") { result in
            
            // Update selection status
            self.sut.updateSelectStatus(for: artist.id, with: true)
            
            // Verify that the artist is selected
            XCTAssertTrue(self.sut.uiArtists.first(where: { $0.id == artist.id })?.isSelected ?? false)
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    /// Tests the functionality to switch between search states.
    /// It verifies that the state toggles correctly.
    func test_switchSearchState() {
        
        // Switch to selected state
        sut.switchSearchState()
        
        // Verify the state is now selected
        XCTAssertEqual(sut.searchState, .selected)
        
        // Switch back to results state
        sut.switchSearchState()
        
        // Verify the state is now results
        XCTAssertEqual(sut.searchState, .results)
    }
    
    /// Tests the reset functionality.
    /// It verifies that the search state is reset to results and the artist list is empty.
    func test_reset() {
        
        // Reset the view model
        sut.reset()
        
        // Verify the state is results
        XCTAssertEqual(sut.searchState, .results)
        
        // Verify that the artist list is empty
        XCTAssertTrue(sut.uiArtists.isEmpty)
    }
    
}
