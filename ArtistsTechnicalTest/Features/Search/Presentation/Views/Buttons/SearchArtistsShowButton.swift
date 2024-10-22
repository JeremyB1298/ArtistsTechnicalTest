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
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    
    /// Sets up the button properties.
    private func setup() {
        setTitle("0 Selected", for: .normal)
        setTitleColor(.tintColor, for: .normal)
        setTitleColor(.lightGray, for: .disabled)
    }
    
}
