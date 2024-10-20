//
//  Factory.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import UIKit

// MARK: - Factory

protocol Factory {
    func makeArtistsViewController() -> UIViewController
}

// MARK: - FactoryImpl

final class FactoryImpl: Factory {
    
    // MARK: - Public method
    
    func makeArtistsViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .blue
        
        return viewController
    }
    
}
