//
//  ArtistUIModel.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

class ArtistUIModel {
    
    // MARK: - Public properties
    
    let id: Int
    let title: String
    var isSelected: Bool
    
    // MARK: - Initializer
    
    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
    
}
