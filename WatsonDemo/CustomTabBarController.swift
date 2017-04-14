//
//  CustomTabBarViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/28/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController, CustomTabBarDataSource, CustomTabBarDelegate, UITabBarControllerDelegate {
    
    
    let customTabBar = CustomTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.isHidden = true
        self.selectedIndex = 0
        self.delegate = self
        
        
        //let newFrame =
        
        self.customTabBar.frame = CGRect(x: 0, y: self.view.frame.size.height-60, width: self.view.frame.size.width, height: 60)
        
        //let customTabBar = CustomTabBar(frame: )//self.tabBar.frame)
        self.customTabBar.datasource = self
        self.customTabBar.delegate = self
        self.customTabBar.setup()
        
        self.customTabBar.tabBarButtons[2].isEnabled = false
        self.customTabBar.tabBarButtons[3].isEnabled = false
        
        self.customTabBar.tabBarButtons[2].alpha = 0.2
        self.customTabBar.tabBarButtons[3].alpha = 0.2
        
        
        self.view.addSubview(self.customTabBar)
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
