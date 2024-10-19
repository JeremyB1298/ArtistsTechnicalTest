//
//  ServiceError.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

enum ServiceError: Error {
    case invalidURL(String)
    case badResponse(Int)
    case decodingError(String)
    case networkError(String)
}
