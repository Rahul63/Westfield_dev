//
//  CustomTabBarViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/28/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController, CustomTabBarDataSource, CustomTabBarDelegate, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.isHidden = true
        self.selectedIndex = 0
        self.delegate = self
        
        //let newFrame =
        
        let customTabBar = CustomTabBar(frame: self.tabBar.frame)
        customTabBar.datasource = self
        customTabBar.delegate = self
        customTabBar.setup()
        
        self.view.addSubview(customTabBar)
    }
    
    // MARK: - CustomTabBarDataSource
    
    func tabBarItemsInCustomTabBar(_ tabBarView: CustomTabBar) -> [UITabBarItem] {
        return tabBar.items!
    }
    
    // MARK: - CustomTabBarDelegate
    
    func didSelectViewController(_ tabBarView: CustomTabBar, atIndex index: Int) {
        self.selectedIndex = index
    }
    
    // MARK: - UITabBarControllerDelegate
    
//    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        return CustomTabAnimatedTransitioning()
//    }

}
