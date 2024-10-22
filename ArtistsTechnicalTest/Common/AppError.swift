//
//  AppError.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// An enumeration representing various errors that can occur within the application.
/// Conforms to the `Error` protocol, allowing it to be thrown in error handling contexts.
enum AppError: Error {
    case invalidURL(String)
    case badResponse(String)
    case decodingError(String)
    case networkError(String)
    
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
        }
    }
}
