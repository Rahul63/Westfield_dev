//
//  CustomTabBarItem.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/28/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class CustomTabBarItem: UIView {
    
    var iconView: UIImageView!
    var titleLbl : UILabel!
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ item: UITabBarItem) {
        
        guard let image = item.image else {
            fatalError("add images to tabbar items")
        }
        
        guard let title = item.title else {
            fatalError("add images to tabbar items")
        }
        print(">>>title\(title)")
        // create imageView centered within a container
        iconView = UIImageView(frame: CGRect(x: (self.frame.width-image.size.width)/2, y: (self.frame.height-image.size.height)/2, width: self.frame.width, height: self.frame.height))
        
        iconView.image = image
        iconView.sizeToFit()
        
        titleLbl = UILabel(frame: CGRect(x: (self.frame.width-image.size.width)/2-6, y: (self.frame.height-14), width: self.frame.width, height: 14))
        titleLbl.font = UIFont.boldSystemFont(ofSize: 11)
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.textColor = UIColor.white
        titleLbl.text = title
        titleLbl.sizeToFit()
        
        iconView.tintColor = UIColor.black
        
        self.addSubview(iconView)
        self.addSubview(titleLbl)
    }
    
}
