//
//  ServiceImplTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 18/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

/// A test case class for testing the `ServiceImpl` implementation of the `Service` protocol.
/// This class verifies that the service correctly handles network requests and responses.
final class ServiceImplTests: XCTestCase {
    
    // MARK: - Private property
    
    /// The system under test (SUT), which is the instance of the `Service` to be tested.
    private var sut: Service!
    
    // MARK: - Setup
    
    /// Sets up the test environment before each test method is invoked.
    /// This method configures a mock URL session for testing.
    override func setUp() {
        
        // Use an ephemeral configuration for testing
        let configuration = URLSessionConfiguration.ephemeral
        
        // Set the mock protocol for intercepting network requests
        configuration.protocolClasses = [MockURLProtocol.self]
        
        // Create a new URL session with the configuration
        let urlSession = URLSession(configuration: configuration)
        
        // Initialize the service with the mock session
        sut = ServiceImpl(session: urlSession)
        
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
    
    /// Tests the `load` method of the service when the response contains valid data.
    func test_fetch_with_results() async {
        
        // Create a mock target
        let mockTarget = MockTarget(baseURL: "https://example.com", path: "/data")
        
        // Create expected data for comparison
        let expectedData = MockDecodableType()
        
        // Define the request handler for the mock URL protocol
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            
            // Verify the request URL
            XCTAssertEqual(url.absoluteString, "https://example.com/data")
            
            // Create a mock response
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            // Encode the expected data to JSON
            let data = try JSONEncoder().encode(expectedData)
            
            // Return the response and data
            return (response, data)
        }
        do {
            
            // Attempt to load data from the service
            let _: MockDecodableType = try await sut.load(target: mockTarget)
        } catch let error {
            
            // Fail the test if an error occurs
            XCTFail("Expected successful load, but got error: \(error)")
        }
    }
    
    /// Tests the `load` method of the service when the response contains invalid JSON data.
    func test_fetch_with_bad_Decoding() async {
        
        // Create a mock target
        let mockTarget = MockTarget(baseURL: "https://example.com", path: "/data")
        
        // Create invalid JSON data
        let invalidJsonData = "{ invalid json }".data(using: .utf8)!
        
        // Define the request handler for the mock URL protocol
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            
            // Verify the request URL
            XCTAssertEqual(url.absoluteString, "https://example.com/data")
            
            // Create a mock response
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            // Return the response and invalid data
            return (response, invalidJsonData)
        }
        
        do {
            
            // Attempt to load data from the service
            let _: MockDecodableType = try await sut.load(target: mockTarget)
            
            // Fail the test if no error occurs
            XCTFail("Expected decoding error, but the call succeeded.")
        } catch let error as ServiceError {
            switch error {
            case .decodingError:
                
                // Pass the test if decoding error occurs
                break
            default:
                
                // Fail the test for unexpected errors
                XCTFail("Expected decoding error, but got different error => \(error)")
            }
        } catch {
            
            // Fail the test for unexpected errors
            XCTFail("Expected ServiceError, but got different error: \(error)")
        }
    }
    
    /// Tests the `load` method of the service when the url is invalid.
    func test_fetch_with_bad_url() async {
        
        // Create a mock target with an invalid URL
        let mockTarget = MockTarget(baseURL: "§§6732", path: "///m")
        
        // Define the request handler for the mock URL protocol
        MockURLProtocol.requestHandler = { _ in
            
            // Simulate a bad URL error
            throw URLError(.badURL)
        }
        
        do {
            // Attempt to load data from the service
            let _: MockDecodableType = try await sut.load(target: mockTarget)
            
            // Fail the test if no error occurs
            XCTFail("Expected decoding error, but the call succeeded.")
        } catch let error as ServiceError {
            switch error {
            case .networkError:
                
                // Pass the test if network error occurs
                break
            default:
                
                // Fail the test for unexpected errors
                XCTFail("Expected decoding error, but got different error => \(error)")
            }
        } catch {
            
            // Fail the test for unexpected errors
            XCTFail("Expected ServiceError, but got different error: \(error)")
        }
    }
    
    /// Tests the `load` method of the service when the status code is invalid.
    func test_fetch_with_invalid_status_code() async {
        
        // Create a mock target
        let mockTarget = MockTarget(baseURL: "https://example.com", path: "/data")
        
        // Create invalid JSON data
        let invalidJsonData = "{ invalid json }".data(using: .utf8)!
        
        // Define the request handler for the mock URL protocol
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            
            // Verify the request URL
            XCTAssertEqual(url.absoluteString, "https://example.com/data")
            
            // Create a mock response with an invalid status code
            let response = HTTPURLResponse(url: url, statusCode: 410, httpVersion: nil, headerFields: nil)!
            
            // Return the response and invalid data
            return (response, invalidJsonData)
        }
        
        do {
            
            // Attempt to load data from the service
            let _: MockDecodableType = try await sut.load(target: mockTarget)
            
            // Fail the test if no error occurs
            XCTFail("Expected decoding error, but the call succeeded.")
        } catch let error as ServiceError {
            switch error {
            case .badResponse(let statusCode):
                
                // Verify the status code in the error
                XCTAssertEqual(statusCode, 410)
            default:
                
                // Fail the test for unexpected errors
                XCTFail("Expected decoding error, but got different error => \(error)")
            }
        } catch {
            
            // Fail the test for unexpected errors
            XCTFail("Expected ServiceError, but got different error: \(error)")
        }
    }
    
}
