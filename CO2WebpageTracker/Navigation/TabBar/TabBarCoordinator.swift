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
    var tabBarController: TabBarController?

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
    
    func switchToSecondTab() {
          tabBarController?.selectedIndex = 1
      }
}

private extension TabBarCoordinator {
    func showTabBarFlow() {
        // 1
        let searchImage = UIImage(systemName: TabBarImageView.search.rawValue)
        let searchNavigationController = UINavigationController()
        searchNavigationController.tabBarItem = UITabBarItem(title: "Search", image: searchImage, selectedImage: searchImage)
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationController, networkService: networkService)
        searchCoordinator.parentCoordinator = self
        searchCoordinator.start()
        // 2
        let listImage = UIImage(systemName: TabBarImageView.list.rawValue)
        let webPageListNavigationController = UINavigationController()
        webPageListNavigationController.tabBarItem = UITabBarItem(title: "Web Pages", image: listImage, selectedImage: listImage)
        let webPageListCoordinator = WebPageListCoordinator(navigationController: webPageListNavigationController, dataService: dataService)
        webPageListCoordinator.parentCoordinator = self
        webPageListCoordinator.start()
        
        // 3
        childCoordinators.append(searchCoordinator)
        childCoordinators.append(webPageListCoordinator)
        
        //4
        let tabBarControllers = [searchNavigationController, webPageListNavigationController]
        tabBarController = TabBarController(tabBarControllers: tabBarControllers)
        // 4
        guard let tabBarController else {return}
        navigationController.pushViewController(tabBarController, animated: false)
    }
}
