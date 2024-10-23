//
//  SearchArtistsShowButton.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

/// A custom button for displaying the count of selected artists.
final class SearchArtistsShowButton: UIButton {
    
    // MARK: - Initializers
    
    /// Initializes a new instance of `SearchArtistsShowButton`.
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
    /// This method configures the title and title colors for the button.
    /// The button's title indicates the number of selected artists,
    /// and it sets the normal and disabled title colors.
    private func setup() {
        
        // Set the initial title
        setTitle("0 Selected", for: .normal)
        
        // Set title color for normal state
        setTitleColor(.tintColor, for: .normal)
        
        // Set title color for disabled state
        setTitleColor(.lightGray, for: .disabled)
    }
    
}
