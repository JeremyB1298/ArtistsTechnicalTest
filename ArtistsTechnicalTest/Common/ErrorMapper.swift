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
            return AppError.invalidURL(string)
        case .badResponse(let int):
            return AppError.badResponse("\(int)")
        case .decodingError(let string):
            return AppError.decodingError(string)
        case .networkError(let string):
            return AppError.networkError(string)
        }
    }
}
