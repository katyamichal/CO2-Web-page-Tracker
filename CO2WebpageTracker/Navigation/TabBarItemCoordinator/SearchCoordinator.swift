//
//  SearchCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 16.06.2024.
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    let networkService: INetworkService
    
    init(navigationController: UINavigationController, networkService: INetworkService) {
        self.navigationController = navigationController
//        self.factory = factory
//        self.dataService = dataService
        self.networkService = networkService
    }
    
    func start() {
        showModule()
    }
}

private extension SearchCoordinator {
    func showModule() {
        let presenter = SearchWebPagePresenter(coordinator: self, networkService: networkService)
        let viewController = SearchWebPageViewController(presenter: presenter)
        navigationController.pushViewController(viewController, animated: true)
    }
}