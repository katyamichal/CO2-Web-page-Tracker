//
//  TabBarController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 17.06.2024.
//

import UIKit
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
        tabBar.tintColor = .green
        tabBar.unselectedItemTintColor = .black
    }
}
