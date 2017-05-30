//
//  ToolBoxDetailView.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/14/17.
//  Copyright © 2017 RAHUL. All rights reserved.
//

import UIKit

class ToolBoxDetailView: NSObject {
    @IBOutlet var detailView: UIView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func shareImageButton(_ sender: UIButton) {
        
        // image to share
        let image = UIImage(named: "Image")
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.detailView // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        //self.present(activityViewController, animated: true, completion: nil)
    }

}
