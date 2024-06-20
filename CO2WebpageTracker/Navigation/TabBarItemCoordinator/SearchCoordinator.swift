//
//  SearchCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 16.06.2024.
//

import UIKit
#warning("прокинуть дата сервис")
final class SearchCoordinator: Coordinator, CoordinatorDetail {
    func showDetail(with id: UUID) {
        let detailCoordinator = WebPageCoordinator(navigationController: navigationController, dataService: DataService(), webPageId: id)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
    
    
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
    
    func showDetail(with dataDTO: WebsiteData) {
        let detailCoordinator = WebPageCoordinator(navigationController: navigationController, dataService: DataService(), dataDto: dataDTO)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
        
    }
}

private extension SearchCoordinator {
    func showModule() {
        let presenter = SearchWebPagePresenter(coordinator: self, networkService: networkService)
        let viewController = SearchWebPageViewController(presenter: presenter)
        navigationController.pushViewController(viewController, animated: true)
    }
}
