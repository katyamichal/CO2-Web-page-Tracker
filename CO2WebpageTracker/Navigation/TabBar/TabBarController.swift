//
//  TabBarController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//
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

final class TabBarController: UITabBarController {
    let screenFactory: ScreenFactory?
    
    init(screenFactory: ScreenFactory?) {
        self.screenFactory = screenFactory
        super.init(nibName: nil, bundle: nil)
        setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TabBarController {
    func setupTabBar() {
        guard
            let firstViewController = screenFactory?.makeSearchScene(),
            let secondViewController = screenFactory?.makeWebPageListScene()
        else { return }
        
        let firstNavController = UINavigationController(rootViewController: firstViewController)
        let secondNavController = UINavigationController(rootViewController: secondViewController)
        tabBar.tintColor = .blue
        tabBar.unselectedItemTintColor = .systemGray
        viewControllers = [firstNavController, secondNavController]
        createTabBarItem(controllers: viewControllers)
    }
    
    func createTabBarItem(controllers: [UIViewController]?) {
        guard let controllers else { return }
        let configuration = UIImage.SymbolConfiguration(pointSize: 21, weight: .light)
        controllers.enumerated().forEach {index, controller in
            let imageName = TabBarImageView.allCases[index]
            let image = UIImage(systemName: imageName.rawValue, withConfiguration: configuration)
            let tabItem = UITabBarItem(title: nil, image: image, selectedImage: image)
            controller.tabBarItem = tabItem
        }
    }
}
