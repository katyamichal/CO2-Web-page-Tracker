//
//  WebPageListCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 15.06.2024.
//

import UIKit

final class WebPageListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
//    let factory: ScreenFactory
    let dataService: IDataService
//    let networkService: INetworkService
    
    init(navigationController: UINavigationController, dataService: IDataService) {
        self.navigationController = navigationController
//        self.factory = factory
        self.dataService = dataService
      //  self.networkService = networkService
    }
    
    func start() {
       showModule()
    }
    
    func showWebPageDetail(with id: UUID) {
        let presenter = WebPagePresenter(dataService: dataService, id: id)
        let viewController = WebPageViewController(presenter: presenter)
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension WebPageListCoordinator {
    func showModule() {
        let presenter = WebPageListPresenter(coordinator: self, dataService: dataService)
        let viewController = WebPageListViewController(presenter: presenter)
        navigationController.pushViewController(viewController, animated: true)
    }
}
