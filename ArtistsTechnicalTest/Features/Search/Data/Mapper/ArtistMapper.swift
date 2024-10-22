//
//  ArtistMapper.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

import Foundation

/// A struct responsible for mapping data transfer objects (DTOs) to domain models.
/// This struct is used to convert `SearchArtistsResultDTO` into an array of `Artist` objects.
struct ArtistMapper {
    
    // MARK: - Public method
    
    /// Maps a `SearchArtistsResultDTO` object to an array of `Artist` objects.
    /// - Parameter searchArtistsResultDTO: The DTO containing artist data to be mapped.
    /// - Returns: An array of `Artist` objects mapped from the provided DTO.
    func map(searchArtistsResultDTO: SearchArtistsResultDTO) -> [Artist] {
        let artistDTOs = searchArtistsResultDTO.data
        
        return artistDTOs.map(map(artistDTO:))
    }
    
    // MARK: - Private method
    
    /// Maps a single `ArtistDTO` object to an `Artist` object.
    /// - Parameter artistDTO: The DTO containing artist data to be mapped.
    /// - Returns: An `Artist` object mapped from the provided DTO.
    private func map(artistDTO: ArtistDTO) -> Artist {
        
        let id = artistDTO.id
        let title = artistDTO.title
        let isSelected = false
        
        return Artist(
            id: id,
            title: title,
            isSelected: isSelected
        )
    }
    
}
