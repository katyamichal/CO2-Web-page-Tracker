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
    private let navigationController: UINavigationController
    private let networkService: INetworkService
    private let dataService: IDataService
    
    init(navigationController: UINavigationController, networkService: INetworkService, dataService: IDataService) {
        self.navigationController = navigationController
        self.dataService = dataService
        self.networkService = networkService
    }
    
    func start() {
        showModule()
    }
    
    func showDetail(with dataDTO: WebsiteData) {
        let detailCoordinator = WebPageCoordinator(navigationController: navigationController, dataService: dataService, dataDto: dataDTO)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
        
    }
    
    func showDetail(with url: String) {
        let detailCoordinator = WebPageCoordinator(navigationController: navigationController, dataService: dataService, webPageURL: url)
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
