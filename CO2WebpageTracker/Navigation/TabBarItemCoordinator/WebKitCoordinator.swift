//
//  WebKitCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 30.07.2024.
//

import UIKit


final class WebKitCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let urlString: String
    
    init(navigationController: UINavigationController, urlString: String) {
        self.navigationController = navigationController
        self.urlString = urlString
    }
    
    func start() {
        showModule()
    }
    
    func goBack() {
        navigationController.dismiss(animated: true)
    }
}

private extension WebKitCoordinator {
    func showModule() {
        let presenter = WebKitPresenter(coordinator: self, url: urlString)
        let viewController = WebKitViewController(presenter: presenter)
        let navController = UINavigationController(rootViewController: viewController)
        navigationController.present(navController, animated: true)
    }
}
