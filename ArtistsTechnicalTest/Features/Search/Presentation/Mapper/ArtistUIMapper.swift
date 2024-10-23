//
//  ArtistUIMapper.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

/// A struct responsible for mapping the domain models to UI models and vice versa.
/// This struct facilitates the conversion between `Artist` and `ArtistUIModel` objects.`
struct ArtistUIMapper {
    
    /// Maps a domain `Artist`object to a UI `ArtistUIModel` object.
    /// - Parameter artist: The domain `Artist` object to be mapped.
    /// - Returns: An `ArtistUIModel` object mapped from the provided domain artist.
    func map(artist: Artist) -> ArtistUIModel {
        
        // Extract properties from the domain Artist
        let id = artist.id
        let title = artist.title
        let isSelected = artist.isSelected
        
        // Create and return the UI model
        return ArtistUIModel(
            id: id,
            title: title,
            isSelected: isSelected
        )
    }
    
    /// Maps a UI `ArtistUIModel` object back to a domain `Artist` object.
    /// - Parameter artistUIModel: The UI `ArtistUIModel` object to be mapped.
    /// - Returns: An `Artist` object mapped from the provided UI model.
    func map(artistUIModel: ArtistUIModel) -> Artist {
        
        // Extract properties from the UI model
        let id = artistUIModel.id
        let title = artistUIModel.title
        let isSelected = artistUIModel.isSelected
        
        // Create and return the domain model
        return Artist(
            id: id,
            title: title,
            isSelected: isSelected
        )
    }
    
}
