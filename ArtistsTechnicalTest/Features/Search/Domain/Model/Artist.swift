//
//  Artist.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// A struct representing an artist in the domain layer.
/// This struct contains properties that define an artist's characteristics.
struct Artist {
    
    /// The unique identifier for the artist.
    let id: Int
    
    /// The title or name of the artist.
    let title: String
    
    /// Indicates whether the artist is currently selected.
    var isSelected: Bool
}
