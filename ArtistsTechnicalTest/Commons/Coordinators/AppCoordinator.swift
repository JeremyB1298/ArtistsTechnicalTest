//
//  AppCoordinator.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import UIKit

/// A coordinator responsible for managing the app's navigation flow.
final class AppCoordinator: Coordinator {
    
    // MARK: - Private properties
    
    private let navigationController: UINavigationController
    private let factory: Factory
    
    // MARK: - Initializer
    
    init(
        navigationController: UINavigationController,
        factory: Factory
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Public method
    
    /// Starts the coordinator by presenting the initial view controller.
    func start() {
        let viewController = factory.makeSearchArtistsViewController()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }
    
}
