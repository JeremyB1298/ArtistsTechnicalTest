//
//  ArtistDTO.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// A struct representing an artist.
/// Conforms to the `Decodable`protocol to enable decoding from JSON data.
struct ArtistDTO: Decodable {
    let id: Int
    let title: String
}
