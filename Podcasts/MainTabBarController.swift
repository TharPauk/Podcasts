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
        setupPlayerDetailView() 
    }
    
    
    
    // MARK: - Setup Functions
    
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    private let playerDetailView = PlayerDetailView.initFromNib()
    
    private func setupPlayerDetailView() {
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint =  playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        NSLayoutConstraint.activate([
            maximizedTopAnchorConstraint,
            playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func maximizePlayerDetailView(episode: Episode?) {
        maximizedTopAnchorConstraint.isActive = true
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        if episode != nil {
            playerDetailView.episode = episode
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            
            self.tabBar.frame.origin.y = self.view.frame.size.height
            
            self.playerDetailView.minimizedView.alpha = 0
            self.playerDetailView.maximizedView.alpha = 1
        }

    }
    
    @objc func minimizePlayerDetailView() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            
            self.playerDetailView.minimizedView.alpha = 1
            self.playerDetailView.maximizedView.alpha = 0
        }

    }
    
    private func setupUI() {
        tabBar.tintColor = .systemPurple
        tabBar.backgroundColor = .systemBackground
        UINavigationBar.appearance().prefersLargeTitles = true
    }
    
    private func setupViewControllers() {
        viewControllers = [
            createNavigationController(for: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            createNavigationController(for: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            createNavigationController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    
    
    // MARK: - Helper Functions
    
    private func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
