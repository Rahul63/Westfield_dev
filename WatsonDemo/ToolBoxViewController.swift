//
//  ToolBoxViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/3/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit
import BoxContentSDK

class ToolBoxViewController: UIViewController,CAPSPageMenuDelegate {
    
    var pageMenu : CAPSPageMenu?
    var controller1 : GeneralSafetyViewController! = nil
    var controller2 : AutoViewController! = nil
    var controller3 : LiabilityViewController! = nil
    var cIndex : Int! = 0
    var controllerArray : [UIViewController] = []
    var itemValue = [BOXItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let boxContent = BOXContentClient.default()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let folderInforequrest = boxContent?.fileInfoRequest(withID: "23139323816")
        
//        boxContent?.authenticate(completionBlock:{(file: BOXUser?, err:Error?) -> Void in
//            if (err == nil) {
//                print("logged In\(file?.login)")
//            }else{
//                //print(err)
//            }
//        })
        
//        [[BOXContentClient defaultClient] authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
//            if (error == nil) {
//            NSLog(@"Logged in user: %@", user.login);
//            }
//            } cancelBlock:nil];
        
        //let folderVc = BOXFolderViewController
        
//        folderInforequrest?.perform(completion: {(file: BOXFile?, err:Error?) -> Void in
//        
//            print(file ?? "not found")
//            print(err ?? "")
//        
//        })
        
        
      /*  let searchFile = boxContent?.searchRequest(withQuery: "All", in: NSMakeRange(0, 1000))
        
        searchFile?.ancestorFolderIDs = ["0"]
        //searchFile?.fileExtensions = [".pdf","jpg","png"]
        searchFile?.perform(completion: {item in
        
            print(" MY Value..\(item.0)")
            
            self.itemValue = item.0! as! [BOXItem]
            print(self.itemValue)
            
            for item in 0..<self.itemValue.count{
                
                let itemData = self.itemValue[item]
                print(itemData)
                if self.itemValue[item].isFile{
                    
                    
                    
                    print(self.itemValue[item].name)
                    print(self.itemValue[item].itemDescription)
                }
                else if self.itemValue[item].isBookmark{
                    print(self.itemValue[item].name)
                    
                let bookMarkItem =  self.itemValue[item] as? BOXBookmark
                    
                if let currentURL = bookMarkItem?.url.absoluteString {
                        
                        print(currentURL)
                        
                    } else {
                        
                        // request is nil ...
                        
                    } 
                    
                    
                    //let descr = ((BOXBookmark)self.itemValue[item]).URL.absoluteString
                    //print(self.itemValue[item].sharedLink)
                }
            }
            
            
        })*/
        self.loadViewUIConstruct()
        
       // NSArray *items, NSUInteger totalCount, NSRange range, NSError *error
//        BOXContentClient *contentClient = [BOXContentClient defaultClient];
//        BOXFolderRequest *folderInfoRequest = [contentClient folderInfoRequestWithID:@"folder-id"];
//        [folderInfoRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
        // If successful, folder will be non-nil; otherwise, error will be non-nil.
   //     }];

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func loadViewUIConstruct()  {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let generalVc = storyBoard.instantiateViewController(withIdentifier: "GeneralSafetyViewController") as! GeneralSafetyViewController
        generalVc.title = "General Safety"
        controllerArray.append(generalVc)
        let autoVc = storyBoard.instantiateViewController(withIdentifier: "AutoViewController") as! AutoViewController
        autoVc.title = "Auto"
        
        controllerArray.append(autoVc)
        let liabilityVc = storyBoard.instantiateViewController(withIdentifier: "LiabilityViewController") as! LiabilityViewController
        liabilityVc.title = "Liability"
        controllerArray.append(liabilityVc)
        let propertyVc = storyBoard.instantiateViewController(withIdentifier: "PropertyViewController") as! PropertyViewController
        propertyVc.title = "Property"
        controllerArray.append(propertyVc)
        
        let width : Int  = Int(self.view.frame.size.width)
        
        let itemWidth = width/controllerArray.count-10
        print(itemWidth)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 216.0/255.0, green: 156.0/255.0, blue: 85.0/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor.white),//(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor.white),
            .BottomMenuHairlineColor(UIColor.white),//(red: 170.0/255.0, green: 170.0/255.0, blue: 180.0/255.0, alpha: 1.0)),
            .UnselectedMenuItemLabelColor(UIColor(red: 99.0/255.0, green: 100.0/255.0, blue: 102.0/255.0, alpha: 1.0)),
            .SelectedMenuItemLabelColor(UIColor.white),
            .MenuItemFont(UIFont.boldSystemFont(ofSize: 12)),
            .MenuHeight(40.0),
            .MenuItemWidth(CGFloat(itemWidth)),
            .CenterMenuItems(true),
            .SelectedMenuItemLabelColor(UIColor.black)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:110.0, width:self.view.frame.width, height:self.view.frame.height-60), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: autoVc)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
