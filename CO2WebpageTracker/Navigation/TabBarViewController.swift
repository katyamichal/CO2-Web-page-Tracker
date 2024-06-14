//
//  TabBarViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//
//
//import UIKit
//
//private enum TabBarImageView: String, CaseIterable {
//    case firstTab = "magnifyingglass"
//    case secondTab = "list.bullet.rectangle.fill"
//}
//
//final class TabBarViewController: UITabBarController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTabBar()
//    }
//    
//    private lazy var searchViewController =
//    
//    private lazy var webPageListView =
//    
//    
//    private func setupTabBar() {
//        tabBar.tintColor = .blue
//        tabBar.unselectedItemTintColor = .systemGray
//        viewControllers?.append(searchViewController)
//        viewControllers?.append(searchViewController)
//        createTabBarItem(controllers: viewControllers)
//    }
//    
//    private func createTabBarItem(controllers: [UIViewController]?) {
//        guard let controllers else { return }
//        
//        let configuration = UIImage.SymbolConfiguration(pointSize: 21, weight: .light)
//        controllers.enumerated().forEach {index, controller in
//            let imageName = TabBarImageView.allCases[index]
//            let image = UIImage(systemName: imageName.rawValue, withConfiguration: configuration)
//            let tabItem = UITabBarItem(title: nil, image: image, selectedImage: image)
//            controller.tabBarItem = tabItem
//        }
//    }
//}

