//
//  SearchArtistsResetButton.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

final class SearchArtistsResetButton: UIButton {
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    
    private func setup() {
        setTitle("Reset", for: .normal)
        setTitleColor(.tintColor, for: .normal)
    }
    
}
