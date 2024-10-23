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
    
    /// The navigation controller used to manage the app's view hierarchy.
    private let navigationController: UINavigationController
    
    /// A factory for creating view controllers and other components.
    private let factory: Factory
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `AppCoordinator`.
    /// - Parameters:
    ///   - navigationController: The navigation controller to manage the app's navigation.
    ///   - factory: The factory used for creating view controllers and components.
    init(
        navigationController: UINavigationController,
        factory: Factory
    ) {
        // Assign the navigation controller
        self.navigationController = navigationController
        
        // Assign the factory
        self.factory = factory
    }
    
    // MARK: - Public method
    
    /// Starts the coordinator by presenting the initial view controller.
    func start() {
        
        // Create the initial view controller
        let viewController = factory.makeSearchArtistsViewController()
        
        // Hide the navigation bar
        navigationController.setNavigationBarHidden(true, animated: false)
        
        // Push the initial view controller onto the navigation stack
        navigationController.pushViewController(viewController, animated: false)
    }
    
}
