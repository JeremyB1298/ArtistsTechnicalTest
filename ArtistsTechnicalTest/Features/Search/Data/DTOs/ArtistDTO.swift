//
//  ArtistDTO.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// A struct representing an artist.
/// Conforms to the `Decodable`protocol to enable decoding from JSON data.
struct ArtistDTO: Decodable {
    
    /// The unique identifier for the artist.
    let id: Int
    
    /// The title or name of the artist.
    let title: String
}
