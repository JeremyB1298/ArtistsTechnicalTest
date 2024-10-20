//
//  Factory.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import UIKit

// MARK: - Factory

protocol Factory {
    func makeSearchArtistsViewController() -> UIViewController
}

// MARK: - FactoryImpl

final class FactoryImpl: Factory {
    
    // MARK: - Public method
    
    func makeSearchArtistsViewController() -> UIViewController {
        let viewController = SearchArtistsViewController()
        viewController.view.backgroundColor = .blue
        
        return viewController
    }
    
}
