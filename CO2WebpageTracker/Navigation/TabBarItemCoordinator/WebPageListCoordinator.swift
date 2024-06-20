//
//  WebPageListCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 15.06.2024.
//

import UIKit

final class WebPageListCoordinator: Coordinator, CoordinatorDetail {
    func showDetail(with id: UUID) {
        showWebPageDetail(with: id)
    }
    
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
        let webPageCoordinator = WebPageCoordinator(navigationController: navigationController, dataService: dataService, webPageId: id)
        webPageCoordinator.parentCoordinator = self
        childCoordinators.append(webPageCoordinator)
        webPageCoordinator.start()
    }
}

private extension WebPageListCoordinator {
    func showModule() {
        let presenter = WebPageListPresenter(coordinator: self, dataService: dataService)
        let viewController = WebPageListViewController(presenter: presenter)
        navigationController.pushViewController(viewController, animated: true)
    }
}
