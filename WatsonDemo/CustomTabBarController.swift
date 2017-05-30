//
//  CustomTabBarViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/28/17.
//  Copyright © 2017 RAHUL. All rights reserved.
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
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(showpinInView(notif:)), name: NSNotification.Name(rawValue: "DropPinInView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoStartPlaying), name:NSNotification.Name(rawValue: "videoPlayingNotification"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(videoEndedPlaying),name: NSNotification.Name(rawValue: "videoEndedPlayingNotification"),object: nil)
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
        self.customTabBar.customTabBarItems[2].alpha = 0.5
        self.customTabBar.customTabBarItems[3].alpha = 0.5
        
        self.customTabBar.tabBarButtons[2].alpha = 0.2
        self.customTabBar.tabBarButtons[3].alpha = 0.2
        
        self.customTabBar.autoresizingMask = .flexibleTopMargin;
        self.view.addSubview(self.customTabBar)
        self.customTabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 20).isActive = true
    }
    
    func videoStartPlaying() {
        self.customTabBar.tabBarButtons[1].isEnabled = false
        self.customTabBar.tabBarButtons[4].isEnabled = false
        self.customTabBar.customTabBarItems[1].alpha = 0.5
        self.customTabBar.customTabBarItems[4].alpha = 0.5
        
        self.customTabBar.tabBarButtons[1].alpha = 0.2
        self.customTabBar.tabBarButtons[4].alpha = 0.2
    }
    
    func videoEndedPlaying() {
        self.customTabBar.tabBarButtons[1].isEnabled = true
        self.customTabBar.tabBarButtons[4].isEnabled = true
        self.customTabBar.customTabBarItems[1].alpha = 1.0
        self.customTabBar.customTabBarItems[4].alpha = 1.0
        self.customTabBar.tabBarButtons[1].alpha = 1.0
        self.customTabBar.tabBarButtons[4].alpha = 1.0
    }
    
    // MARK: - CustomTabBarDataSource
    
    func tabBarItemsInCustomTabBar(_ tabBarView: CustomTabBar) -> [UITabBarItem] {
        return tabBar.items!
    }
    
    func showpinInView(notif:NSNotification){
        
        let value = notif.userInfo
        let fromValue = Int(value?["from"] as? String ?? "")
        let toValue = Int(value?["to"] as? String ?? "")
//        print(fromValue)
//        print(toValue)
        
        animateTabb(with: fromValue!, and: toValue!)
    }
    
    func animateTabb(with from: Int,and to: Int) {
        customTabBar.animateTabBarSelection(from: 0, to: to)
    }
    
    // MARK: - CustomTabBarDelegate
    
    func didSelectViewController(_ tabBarView: CustomTabBar, atIndex index: Int) {
        
        if self.selectedIndex != index {
            customTabBar.hidePinView()
        }
        self.selectedIndex = index
        self.setNeedsStatusBarAppearanceUpdate()
        //self.prefersStatusBarHidden
    }
    
//    override var shouldAutorotate: Bool {
//        return false
//    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //swift 3
        //getScreenSize()
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
    }
    

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
//
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    // MARK: - UITabBarControllerDelegate
    
//    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        return CustomTabAnimatedTransitioning()
//    }

}
