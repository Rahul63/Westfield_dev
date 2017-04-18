//
//  CustomTabBar.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/28/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

protocol CustomTabBarDataSource {
    func tabBarItemsInCustomTabBar(_ tabBarView: CustomTabBar) -> [UITabBarItem]
}

protocol CustomTabBarDelegate {
    func didSelectViewController(_ tabBarView: CustomTabBar, atIndex index: Int)
}

class CustomTabBar: UIView {
    
    var datasource: CustomTabBarDataSource!
    var delegate: CustomTabBarDelegate!
    
    var tabBarItems: [UITabBarItem]!
    var customTabBarItems: [CustomTabBarItem]!
    var tabBarButtons: [UIButton]!
    
    var initialTabBarItemIndex: Int!
    var selectedTabBarItemIndex: Int!
    var slideMaskDelay: Double!
    var slideAnimationDuration: Double!
    
    var tabBarItemWidth: CGFloat!
    var leftMask: UIView!
    var rightMask: UIView!
    let selectedImageArray = ["advice_selected","toolBox_selected","news_selected","progress_selected","settings_selected"]
    let unSelectedImageArray = ["Advice_icon","ToolBoxNew","NewsNew","Progress_icon","SettingsNew"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 216.0/255, green: 156.0/255, blue: 85.0/255, alpha: 1)//UIColor(netHex:0xd89c54)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        // get tab bar items from default tab bar
        tabBarItems = datasource.tabBarItemsInCustomTabBar(self)
        
        customTabBarItems = []
        tabBarButtons = []
        
        initialTabBarItemIndex = 0
        selectedTabBarItemIndex = initialTabBarItemIndex
        
        slideAnimationDuration = 0.6
        slideMaskDelay = slideAnimationDuration / 2
        
        let containers = createTabBarItemContainers()
        
        //createTabBarItemSelectionOverlayMask(containers)
        createTabBarItems(containers)
    }
    
    
    func createTabBarItems(_ containers: [CGRect]) {
        
        var index = 0
        for item in tabBarItems {
            
            let container = containers[index]
            
            let customTabBarItem = CustomTabBarItem(frame: container)
            customTabBarItem.setup(item)
            
            self.addSubview(customTabBarItem)
            customTabBarItems.append(customTabBarItem)
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: container.width, height: container.height))
            
            
            button.addTarget(self, action: #selector(CustomTabBar.barItemTapped(_:)), for: UIControlEvents.touchUpInside)
            
            customTabBarItem.addSubview(button)
            tabBarButtons.append(button)
            
            index += 1
        }
        
        
        self.customTabBarItems[0].iconView.image = UIImage(named : "advice_selected")
        self.customTabBarItems[0].titleLbl.textColor = UIColor.brown
        self.customTabBarItems[2].iconView.alpha = 0.5
        self.customTabBarItems[3].iconView.alpha = 0.5
    }
    
    func createTabBarItemContainers() -> [CGRect] {
        
        var containerArray = [CGRect]()
        
        // create container for each tab bar item
        for index in 0..<tabBarItems.count {
            let tabBarContainer = createTabBarContainer(index)
            containerArray.append(tabBarContainer)
        }
        
        return containerArray
    }
    
    func createTabBarContainer(_ index: Int) -> CGRect {
        
        let tabBarContainerWidth = self.frame.width / CGFloat(tabBarItems.count)
        let tabBarContainerRect = CGRect(x: tabBarContainerWidth * CGFloat(index), y: 0, width: tabBarContainerWidth, height: self.frame.height)
        
        return tabBarContainerRect
    }
    
//    func TabBarSelection(from: Int, to: Int) {
//        
//        let overlaySlidingMultiplier = CGFloat(to - from) * tabBarItemWidth
//        
//        let leftMaskDelay: Double
//        let rightMaskDelay: Double
//        if overlaySlidingMultiplier > 0 {
//            leftMaskDelay = slideMaskDelay
//            rightMaskDelay = 0
//        }
//        else {
//            leftMaskDelay = 0
//            rightMaskDelay = slideMaskDelay
//        }
//        
//        UIView.animate(withDuration: slideAnimationDuration - leftMaskDelay, delay: leftMaskDelay, options: UIViewAnimationOptions(), animations: {
//            self.leftMask.frame.size.width += overlaySlidingMultiplier
//            }, completion: nil)
//        
//        UIView.animate(withDuration: slideAnimationDuration - rightMaskDelay, delay: rightMaskDelay, options: UIViewAnimationOptions(), animations: {
//            self.rightMask.frame.origin.x += overlaySlidingMultiplier
//            self.rightMask.frame.size.width += -overlaySlidingMultiplier
//            self.customTabBarItems[from].iconView.tintColor = UIColor.black
//            self.customTabBarItems[to].iconView.tintColor = UIColor.blue
//            }, completion: nil)
//        
//    }
    
    func barItemTapped(_ sender : UIButton) {
        let index = tabBarButtons.index(of: sender)!
        
        self.customTabBarItems[selectedTabBarItemIndex].iconView.image = UIImage(named : unSelectedImageArray[selectedTabBarItemIndex])
        self.customTabBarItems[selectedTabBarItemIndex].titleLbl.textColor = UIColor.white
        self.customTabBarItems[index].iconView.image = UIImage(named : selectedImageArray[index])
        self.customTabBarItems[index].titleLbl.textColor = UIColor.brown
        //animateTabBarSelection(from: selectedTabBarItemIndex, to: index)
        selectedTabBarItemIndex = index
        delegate.didSelectViewController(self, atIndex: index)
    }
}
