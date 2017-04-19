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
        
       // self.customTabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        //self.customTabBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
//        self.view.addConstraint(NSLayoutConstraint(item: self.customTabBar, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
//        
//        self.view.addConstraint(NSLayoutConstraint(item: self.customTabBar, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute:.top, multiplier: 1, constant: 20))
//        
//        self.view.addConstraint(NSLayoutConstraint(item: self.customTabBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 300))
//        view.addConstraint(NSLayoutConstraint(item: self.customTabBar, attribute: .trailingMargin, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: 0))
        
        
        //self.customTabBar.
        
        //let customTabBar = CustomTabBar(frame: )//self.tabBar.frame)
        self.customTabBar.datasource = self
        self.customTabBar.delegate = self
        self.customTabBar.setup()
        
        self.customTabBar.tabBarButtons[2].isEnabled = false
        self.customTabBar.tabBarButtons[3].isEnabled = false
        
        self.customTabBar.tabBarButtons[2].alpha = 0.2
        self.customTabBar.tabBarButtons[3].alpha = 0.2
        
        self.customTabBar.autoresizingMask = .flexibleTopMargin;
        self.view.addSubview(self.customTabBar)
        self.customTabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 20).isActive = true
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
