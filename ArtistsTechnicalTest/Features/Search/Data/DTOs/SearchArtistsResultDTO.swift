//
//  SearchArtistsResultDTO.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// A struct representing the result of a search for artists.
/// Conforms to the `Decodable`protocol to enable decoding from JSON data.
struct SearchArtistsResultDTO: Decodable {
    let data: [ArtistDTO]
}
