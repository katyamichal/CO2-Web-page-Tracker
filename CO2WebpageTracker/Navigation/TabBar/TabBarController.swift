//
//  TabBarController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//
//
import UIKit

//final class TabBarController: UITabBarController {
//    let screenFactory: ScreenFactory?
//    let dependencies: ScreenFactory.Dependencies
//    let coordinator: Coordinator

//    enum TabBarImageView: String, CaseIterable {
//        case search = "magnifyingglass"
//        case list = "list.bullet.clipboard"
//    }
//    
//    init(screenFactory: ScreenFactory?, depen: ScreenFactory.Dependencies, coordinator: Coordinator) {
////        self.screenFactory = screenFactory
////        self.dependencies = depen
////        self.coordinator = coordinator
//        super.init(nibName: nil, bundle: nil)
//     //   setupTabBar()
//    }
   
    
//    init(tabBarControllers: [UIViewController]) {
//        super.init(nibName: nil, bundle: nil)
//        for tab in tabBarControllers {
//            addChild(tab)
//        }
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//private extension TabBarController {
//    func setupTabBar() {
//        guard
//            let firstViewController = screenFactory?.makeSearchScene(dependencies: dependencies),
//            let secondViewController = screenFactory?.makeWebPageListScene(dependencies: dependencies)
//        else { return }
//        
//        let firstNavController = UINavigationController(rootViewController: firstViewController)
//        let secondNavController = UINavigationController(rootViewController: secondViewController)
//        tabBar.tintColor = .black
//        tabBar.unselectedItemTintColor = .systemGray
//        viewControllers = [firstNavController, secondNavController]
//        createTabBarItem(controllers: viewControllers)
//    }
//    
//    func createTabBarItem(controllers: [UIViewController]?) {
//        guard let controllers else { return }
//        let configuration = UIImage.SymbolConfiguration(pointSize: 21, weight: .light)
//        controllers.enumerated().forEach {index, controller in
//            let imageName = TabBarImageView.allCases[index]
//            let image = UIImage(systemName: imageName.rawValue, withConfiguration: configuration)
//            let tabItem = UITabBarItem(title: nil, image: image, selectedImage: image)
//            controller.tabBarItem = tabItem
//        }
//    }
//}


final class TabBarController: UITabBarController {
    
    init(tabBarControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        for tab in tabBarControllers {
            addChild(tab)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarStyle()
    }
}

private extension TabBarController {
    func setupTabBarStyle() {
        tabBar.backgroundColor = .white.withAlphaComponent(0.3)
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .black
    }
}
