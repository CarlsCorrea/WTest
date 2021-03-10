//
//  PostalCodeCoordinator.swift
//  WTest
//
//  Created by Carlos Correa on 08/03/2021.
//

import Foundation

final class PostalCodeCoordinator: Coordinator {
    private let navigator: NavigationController
    private var nextCoordinator: Coordinator?
    
    init(navigator: NavigationController) {
        self.navigator = navigator
    }
    
    func start() {
        let viewModel = PostalCodeViewModel()
        let viewController = PostalCodeViewController(viewModel: viewModel)
        navigator.pushViewController(viewController, animated: true)
    }
}
