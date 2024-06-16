//
//  TabBarCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 16.06.2024.
//

import UIKit

enum TabBarImageView: String, CaseIterable {
    case search = "magnifyingglass"
    case list = "list.bullet.clipboard"
}

final class TabBarCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let window: UIWindow?
   // private let factory: ScreenFactory?
    private let networkService: INetworkService
    private let dataService: IDataService

    // MARK: - Init

    init(window: UIWindow?, networkService: INetworkService, dataService: IDataService, navigationController: UINavigationController) {
        self.window = window
        //self.factory = factory
        self.networkService = networkService
        self.dataService = dataService
        self.navigationController = navigationController
    }
    
    func start() {
        showTabBarFlow()
    }
    
    func showSearchDetailModule() {
        
    }
}

private extension TabBarCoordinator {
    func showTabBarFlow() {
        let searchImage = UIImage(systemName: TabBarImageView.search.rawValue)
        let searchNavigationController = UINavigationController()
        searchNavigationController.tabBarItem = UITabBarItem(title: "Search", image: searchImage, selectedImage: searchImage)
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationController, networkService: networkService)
        searchCoordinator.start()
        
        let listImage = UIImage(systemName: TabBarImageView.list.rawValue)
        let webPageListNavigationController = UINavigationController()
        webPageListNavigationController.tabBarItem = UITabBarItem(title: "Web Pages", image: listImage, selectedImage: listImage)
        let webPageListCoordinator = WebPageListCoordinator(navigationController: webPageListNavigationController, dataService: dataService)
        webPageListCoordinator.start()
        
        childCoordinators.append(searchCoordinator)
        childCoordinators.append(webPageListCoordinator)
        
        let tabBarControllers = [searchNavigationController, webPageListNavigationController]
        let tabBarController = TabBarController(tabBarControllers: tabBarControllers)
        
        navigationController.pushViewController(tabBarController, animated: false)
    }
}
