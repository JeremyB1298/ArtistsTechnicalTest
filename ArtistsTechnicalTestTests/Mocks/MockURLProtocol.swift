//
//  MockURLProtocol.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

import Foundation

/// A custom URLProtocol subclass used for mocking network requests in tests.
/// This class intercepts network requests and allows for the configuration of mock responses.
class MockURLProtocol: URLProtocol {
    
    // MARK: - Public property
    
    /// A closure that handles incoming requests and provides mock responses.
    /// This closure must be set to intercept requests and return a response.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    // MARK: - Public methods
    
    /// Determines whether the protocol can handle a given request.
    /// - Parameter request: The URL request to evaluate.
    /// - Returns: A Boolean value indicating whether the request can be handled. Always returns true to intercept all requests.
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    /// Provides the canonical version of the specified URL request.
    /// - Parameter request: The original URL request.
    /// - Returns: The canonical version of the request, which in this case is the original request itself.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /// Begins loading the request and provides the mock response.
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Request handler not set")
        }
        
        do {
            let (response, data) = try handler(request)
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        } catch {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    /// Stops loading the request. This method can be overridden for cleanup if necessary.
    override func stopLoading() {
        // Clean up if necessary
    }
}
