//
//  Service.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 18/10/2024.
//

import Foundation

// MARK: - Service

/// A protocol defining the requirements for a service that handles network requests.
protocol Service {
    /// Loads a resource from the given target and decodes it into the specified type.
    /// - Parameter target: The target type defining the base URL and path for the request.
    /// - Returns: A decoded object of type `T`, which conforms to `Decodable`
    /// - Throws: An error if the network request fails or if decoding fails.
    func load<T: Decodable>(target: TargetType) async throws -> T
}

// MARK: - ServiceImpl

/// A final implementation of the `Service` protocol that handles network requests.
/// This class provides methods for loading resources from a specified target using a URL session.
final class ServiceImpl: Service {
    
    // MARK: - Private property
    
    /// The URL session used for making network requests.
    private var session: URLSession
    
    /// A range of valid HTTP status codes indicating success.
    private let validStatusCodes = 200...299
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `ServiceImpl` with a specified URL session.
    /// - Parameter session: The URL session to use for network requests (default is `URLSession.shared`).
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Public method
    
    /// Loads a resource from the given target and decodes it into the specified type.
    /// - Parameter target: The target type defining the base URL and path for the request.
    /// - Returns: A decoded object of type `T`, which conforms to `Decodable`.
    /// - Throws: `ServiceError.networkError` if a network error occurs,
    ///           `ServiceError.badResponse` if the response is not valid,
    ///           or `ServiceError.decodingError` if the data cannot be decoded.
    func load<T: Decodable>(target: TargetType) async throws -> T {
        
        // Build the URL from the target
        let url = try buildUrl(target: target)
        
        let data: Data
        let response: URLResponse
        
        do {
            
            // Perform the network request
            (data, response) = try await session.data(from: url)
        } catch let error {
            
            // Handle network error
            throw ServiceError.networkError(error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            
            // Handle invalid response
            throw ServiceError.badResponse(-1)
        }
        
        guard (validStatusCodes).contains(httpResponse.statusCode) else {
            
            // Handle non-success status codes
            throw ServiceError.badResponse(httpResponse.statusCode)
        }
        
        // Create a JSON decoder
        let decoder = JSONDecoder()
        
        do {
            
            // Decode the data into the specified type
            return try decoder.decode(T.self, from: data)
        } catch let error {
            
            // Convert data to string for error logging
            let dataString = String(data: data, encoding: .utf8) ?? "No data"
            
            // Handle decoding error
            throw ServiceError.decodingError("Decoding error for \(T.self), with error: \(error), data: \(dataString)")
        }
    }
    
    // MARK: - Private method
    
    /// Constructs a URL from the given target type.
    /// - Parameter target: The target type defining the base URL and path.
    /// - Returns: The constructed URL.
    /// - Throws: `ServiceError.invalidURL` if the constructed URL is invalid.
    private func buildUrl(target: TargetType) throws -> URL {
        
        // Construct the URL string
        let urlString = target.baseURL + target.path
        
        guard let url = URL(string: urlString) else {
            
            // Handle invalid URL
            throw ServiceError.invalidURL(urlString)
        }
        
        // Return the constructed URL
        return url
    }
}
