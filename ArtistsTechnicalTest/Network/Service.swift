//
//  Service.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 18/10/2024.
//

import Foundation

// MARK: - Service Error

enum ServiceError: Error {
    case invalidURL(String)
    case badResponse(Int)
    case decodingError(String)
    case networkError(String)
}

// MARK: - Service

final class Service {
    
    // MARK: - Private property
    
    private var session = URLSession.shared
    private let validStatusCodes = 200...299
    
    // MARK: - Public method
    
    func load<T: Decodable>(target: Target) async throws -> T {
        let url = try buildUrl(target: target)
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(from: url)
        } catch let error {
            throw ServiceError.networkError(error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.badResponse(-1)
        }
        
        guard (validStatusCodes).contains(httpResponse.statusCode) else {
            throw ServiceError.badResponse(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error {
            throw ServiceError.decodingError("Decoding error for \(T.self)")
        }
    }
    
    // MARK: - Private method
    
    private func buildUrl(target: Target) throws -> URL {
        let urlString = target.baseURL + target.path
        
        guard let url = URL(string: urlString) else {
            throw ServiceError.invalidURL(urlString)
        }
        
        return url
    }
}

// MARK: - Target

protocol Target {
    var baseURL: String { get }
    var path: String { get }
}
