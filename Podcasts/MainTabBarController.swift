//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by Min Thet Maung on 31/12/2020.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewControllers()
    }
    
    
    
    // MARK: - Setup Functions
    
    private func setupUI() {
        tabBar.tintColor = .systemPurple
        tabBar.backgroundColor = .systemBackground
        UINavigationBar.appearance().prefersLargeTitles = true
    }
    
    private func setupViewControllers() {
        viewControllers = [
            createNavigationController(for: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            createNavigationController(for: ViewController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            createNavigationController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    
    
    // MARK:- Helper Functions
    
    private func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
