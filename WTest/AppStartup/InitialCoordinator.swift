//
//  InitialCoordinator.swift
//  WTest
//
//  Created by Carlos Correa on 08/03/2021.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

final class InitialCoordinator: Coordinator {
    private let window: UIWindow
    private let navigator: NavigationController
    private var nextCoordinator: Coordinator?
    
    init(window: UIWindow = UIWindow(frame: UIScreen.main.bounds),
         windowScene: UIWindowScene,
         navigator: NavigationController = NavigationController()
    ) {
        self.window = window
        self.window.windowScene = windowScene
        self.navigator = navigator
    }
    
    func start() {
        window.rootViewController = navigator
        window.makeKeyAndVisible()
        navigator.navigationBar.prefersLargeTitles = true
        let nextCoordinator = PostalCodeCoordinator(navigator: navigator)
        nextCoordinator.start()
        self.nextCoordinator = nextCoordinator
    }
}
