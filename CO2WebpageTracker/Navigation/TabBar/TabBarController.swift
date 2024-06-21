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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        var appState = AppStateService.shared.retrieve()
        appState?.currentTab = Tab(rawValue: selectedIndex) ?? .search
        guard let appState else { return }
        AppStateService.shared.save(appState: appState)
    }
}

private extension TabBarController {
    func setupTabBarStyle() {
        tabBar.backgroundColor = .black
        tabBar.barTintColor = .black
        tabBar.tintColor = Colours.WebPageColours.blue
        tabBar.unselectedItemTintColor = .white
    }
}


