//
//  ServiceError.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// An enumeration representing various errors that can occur within the `Service` implementation.
/// Conforms to the `Error` protocol, allowing it to be thrown in error handling contexts.
enum ServiceError: Error {
    
    /// Indicates that the constructed URL is invalid.
    /// - Parameter urlString: The invalid URL string that caused the error.
    case invalidURL(String)
    
    /// Indicates that the network response was not valid.
    /// - Parameter statusCode: The HTTP status code received in the response.
    case badResponse(Int)
    
    /// Indicates that there was an error while decoding the data.
    /// - Parameter message: A description of the decoding error.
    case decodingError(String)
    
    /// Indicates that a network error occurred during the request.
    /// - Parameter message: A description of the network error.
    case networkError(String)
}
