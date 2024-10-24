//
//  SceneDelegate.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 18/10/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Private property
    
    /// The main coordinator responsible for navigating through the app's scenes.
    private var appCoordinator: Coordinator!
    
    /// A factory instance used to create various components in the app.
    private let factory: Factory = FactoryImpl()
    
    // MARK: - Public property
    
    /// The main window for the app, used for displaying the UI.
    var window: UIWindow?
    
    // MARK: - Public methods
    
    
    /// Called when the scene is about to connect to the app's session.
    /// This method sets up the window and its root view controller.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // Ensure the scene is a UIWindowScene
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // Create a new window with the provided windowScene
        window = UIWindow(windowScene: windowScene)
        
        // Create a navigation controller to manage the app's navigation stack
        let navigationController = UINavigationController()
        
        // Set the navigation controller as the root view controller of the window
        window?.rootViewController = navigationController
        
        // Make the window visible and key
        window?.makeKeyAndVisible()
        
        // Initialize the app coordinator with the navigation controller and factory
        appCoordinator = AppCoordinator(navigationController: navigationController, factory: factory)
        
        // Start the app coordinator to begin navigation
        appCoordinator.start()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}

