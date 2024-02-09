//
//  MainTabBarVC.swift
//  HarshDemoPractical
//
//  Created by My Mac Mini on 09/02/24.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .systemRed
        
        let mainStory: UIStoryboard = UIStoryboard(name: Constant.STORY_BOARD_MAIN, bundle: nil)
        
        guard let homeVC = mainStory.instantiateViewController(withIdentifier: Constant.VC_HOME) as? HomeVC else { return }
        let navigationHome = UINavigationController(rootViewController: homeVC)
        
        guard let favVC = mainStory.instantiateViewController(withIdentifier: Constant.VC_FAVOURITE) as? FavouriteVC else { return }
        let navigationFav = UINavigationController(rootViewController: favVC)
        
        navigationHome.tabBarItem.image = UIImage(systemName: "house")
        navigationHome.tabBarItem.title = "Home"
        navigationHome.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        navigationHome.navigationBar.prefersLargeTitles = true
        
        navigationFav.tabBarItem.image = UIImage(systemName: "star")
        navigationFav.tabBarItem.title = "Favourites"
        navigationFav.tabBarItem.selectedImage = UIImage(systemName: "star.fill")
        navigationFav.navigationBar.prefersLargeTitles = true
       
        setViewControllers([navigationHome,navigationFav], animated: true)
        
        
    }
    
    
}

