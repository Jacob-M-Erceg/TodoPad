//
//  TabBarController.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    // MARK: - Helpers
    private func setupViewControllers() {
        let tasks = self.templateNavigationController(image: UIImage(systemName: "list.bullet"), title: "Tasks", rootViewController: TasksController())
        
        let stats = self.templateNavigationController(image: UIImage(systemName: "chart.bar.fill"), title: "Stats", rootViewController: StatsController())
        
        self.setViewControllers([tasks, stats], animated: false)
    }
    
    private func templateNavigationController(image: UIImage?, title: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        nav.viewControllers[0].title = title
        nav.setupNavBarColor()
        return nav
    }
    
}
