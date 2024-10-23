//
//  ArtistUIModel.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

/// A struct representing an artist in the UI layer.
/// This struct contains properties that define the artist's characteristics as they are presented in the user interface.
struct ArtistUIModel {
    
    /// The unique identifier for the artist.
    let id: Int
    
    /// The title or name of the artist.
    let title: String
    
    /// Indicates whether the artist is currently selected in the UI.
    var isSelected: Bool
}
