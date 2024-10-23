//
//  SearchArtistsResetButton.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

/// A custom button for resetting the selection of artists.
final class SearchArtistsResetButton: UIButton {
    
    // MARK: - Initializers
    
    /// Initializes a new instance of `SearchArtistsResetButton`.
    /// This initializer sets up the button with the default properties.
    init() {
        super.init(frame: .zero)
        
        // Call the setup method to configure button properties
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    
    /// Sets up the button properties.
    /// This method configures the title for the button and sets its title color.
    /// The button's title indicates the action it performs, which is to reset the selection.
    private func setup() {
        
        // Set the button title
        setTitle("Reset", for: .normal)
        
        // Set title color for normal state
        setTitleColor(.tintColor, for: .normal)
    }
    
}
