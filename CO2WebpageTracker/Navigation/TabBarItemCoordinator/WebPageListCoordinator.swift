//
//  WebPageListCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 15.06.2024.
//

import UIKit

final class WebPageListCoordinator: Coordinator, CoordinatorDetail {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private  let dataService: IDataService
    
    init(navigationController: UINavigationController, dataService: IDataService) {
        self.navigationController = navigationController
        self.dataService = dataService
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
    
    func showDetail(with id: UUID) {
        showWebPageDetail(with: id)
    }
}

private extension WebPageListCoordinator {
    func showModule() {
        let presenter = WebPageListPresenter(coordinator: self, dataService: dataService)
        let viewController = WebPageListViewController(presenter: presenter)
        navigationController.pushViewController(viewController, animated: true)
    }
}
