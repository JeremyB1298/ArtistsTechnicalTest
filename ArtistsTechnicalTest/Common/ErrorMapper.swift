//
//  ErrorMapper.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// A struct responsible for mapping `ServiceError` instances to `AppError` instances.
/// This struct provides a centralized way to translate service-specific errors into application-level errors.
struct ErrorMapper {
    
    /// Maps a `ServiceError` instance to an `AppError` instance.
    /// - Parameter serviceError: The `ServiceError` to be mapped.
    /// - Returns: An `AppError` instance that corresponds to the provided `ServiceError`.
    func map(serviceError: ServiceError) -> AppError {
        switch serviceError {
        case .invalidURL(let string):
            let description = """
            An error occurred on the network called due to invalid url:
            \(string)
            """
            return AppError.invalidURL(description)
        case .badResponse(let int):
            let description = """
            An error occurred on the network called due bad response:
            Status \(int)
            """
            return AppError.badResponse(description)
        case .decodingError(let string):
            let description = """
            An error occurred on the network called due bad decoding:
            \(string)
            """
            return AppError.decodingError(description)
        case .networkError(let string):
            let description = """
            An error occurred on the network called:
            \(string)
            """
            return AppError.networkError(description)
        }
    }
}
