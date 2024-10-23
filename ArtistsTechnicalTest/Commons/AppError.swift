//
//  AppError.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// An enumeration representing various errors that can occur within the application.
/// Conforms to the `Error` protocol, allowing it to be thrown in error handling contexts.
enum AppError: Error {
    
    /// Indicates that an invalid URL was encountered.
    /// - Parameter string: The invalid URL string that caused the error.
    case invalidURL(String)
    
    /// Indicates that a bad response was received from the server.
    /// - Parameter string: A description of the response status or error.
    case badResponse(String)
    
    /// Indicates that an error occurred during data decoding.
    /// - Parameter string: A description of the decoding error.
    case decodingError(String)
    
    /// Indicates that a network error occurred.
    /// - Parameter string: A description of the network error.
    case networkError(String)
    
    /// Indicates an internal application error.
    /// - Parameter string: A description of the internal error.
    case internalError(String)
    
    /// A computed property that provides a localized description of the error.
    /// - Returns: A detailed error message that can be presented to the user.
    var localizationDescription: String {
        switch self {
        case .invalidURL(let string):
            return """
            An error occurred on the network called due to invalid url:
            \(string)
            """
        case .badResponse(let string):
            return """
            An error occurred on the network called due bad response:
            Status \(string)
            """
        case .decodingError(let string):
            return """
            An error occurred on the network called due bad decoding:
            \(string)
            """
        case .networkError(let string):
            return """
            An error occurred on the network called:
            \(string)
            """
        case .internalError(let string):
            return """
            An internal error occured:
            \(string)
            """
        }
    }
}
