//
//  ArtistUIMapper.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

struct ArtistUIMapper {
    
    func map(artist: Artist) -> ArtistUIModel {
        
        let id = artist.id
        let title = artist.title
        let isSelected = artist.isSelected
        
        return ArtistUIModel(
            id: id,
            title: title,
            isSelected: isSelected
        )
    }
    
    func map(artistUIModel: ArtistUIModel) -> Artist {
        
        let id = artistUIModel.id
        let title = artistUIModel.title
        let isSelected = artistUIModel.isSelected
        
        return Artist(
            id: id,
            title: title,
            isSelected: isSelected
        )
    }
    
}
