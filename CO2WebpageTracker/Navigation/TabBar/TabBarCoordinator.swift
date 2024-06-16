//
//  TabBarCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 16.06.2024.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let screenFactory: ScreenFactory?

    init(navigationController: UINavigationController, screenFactory: ScreenFactory?) {
        self.navigationController = navigationController
        self.screenFactory = screenFactory
    }
    
    func start() {
        let tabBarController = TabBarController(screenFactory: screenFactory)
        navigationController.viewControllers = [tabBarController]
    }
}
