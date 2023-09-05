//
//  ViewController.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 5.09.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        vc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        vc2.tabBarItem = UITabBarItem(title: "Coming Soon", image: UIImage(systemName: "play.circle"), tag: 1)
        vc3.tabBarItem = UITabBarItem(title: "Top Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        vc4.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.to.line"), tag: 3)
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}

