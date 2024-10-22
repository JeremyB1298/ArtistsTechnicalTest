//
//  AppErrorTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 22/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

/// Test class for `AppError` enumeration.
final class AppErrorTests: XCTestCase {
    
    // MARK: - Tests
    
    /// Tests the error message for invalid URL error.
    func test_invalid_url() {
        let string = "wrong url www.test.com"
        let error = AppError.invalidURL(string)
        let localizationDescription = error.localizationDescription
        
        XCTAssertEqual(
            localizationDescription,
            """
            An error occurred on the network called due to invalid url:
            wrong url www.test.com
            """
        )
    }
    
    /// Tests the error message for bad response error.
    func test_bad_response() {
        let string = "bad response 410"
        let error = AppError.badResponse(string)
        let localizationDescription = error.localizationDescription
        
        XCTAssertEqual(
            localizationDescription,
            """
            An error occurred on the network called due bad response:
            Status bad response 410
            """
        )
    }
    
    /// Tests the error message for decoding error.
    func test_decoding_error() {
        let string = "decoding error"
        let error = AppError.decodingError(string)
        let localizationDescription = error.localizationDescription
        
        XCTAssertEqual(
            localizationDescription,
            """
            An error occurred on the network called due bad decoding:
            decoding error
            """
        )
    }
    
    /// Tests the error message for network error.
    func test_network_error() {
        let string = "network error"
        let error = AppError.networkError(string)
        let localizationDescription = error.localizationDescription
        
        XCTAssertEqual(
            localizationDescription,
            """
            An error occurred on the network called:
            network error
            """
        )
    }
    
    /// Tests the error message for internal error.
    func test_internal_error() {
        let string = "internal error"
        let error = AppError.internalError(string)
        let localizationDescription = error.localizationDescription
        
        XCTAssertEqual(
            localizationDescription,
            """
            An internal error occured:
                    internal error
            """
        )
    }
    
}
