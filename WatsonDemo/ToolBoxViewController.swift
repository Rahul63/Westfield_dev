//
//  ToolBoxViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/3/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit
import BoxContentSDK

protocol ToolBoxSearchDelegate
{
    func searchedWithValue(with value:String)
    
}

class ToolBoxViewController: UIViewController,CAPSPageMenuDelegate,AutoViewDelegate,UITextFieldDelegate {
    
    var pageMenu : CAPSPageMenu?
    var controller1 : GeneralSafetyViewController! = nil
    var controller2 : AutoViewController! = nil
    var controller3 : LiabilityViewController! = nil
    @IBOutlet var SearchTxt: UITextField!
    var search:String=""
    var cIndex : Int! = 0
    @IBOutlet weak var headerView: UIView!
    var controllerArray : [UIViewController] = []
    var itemValue = [BOXItem]()
    var  urlStr = ""
    var delegate: ToolBoxSearchDelegate?
    var isSignOut = false
    

    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var backArrowImage: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    override func viewDidLoad() {
        SearchTxt.delegate = self
        
        super.viewDidLoad()
        let boxContent = BOXContentClient.default()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.headerView.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.headerView.frame.size.height)
        self.headerView.setNeedsDisplay()
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.playerDidFinishPlaying),name:NSNotification.Name.UIWindowDidBecomeHidden,object:nil)
        
        
 //       let folderInforequrest = boxContent?.fileInfoRequest(withID: "23139323816")
        
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
    
    
    func playerDidFinishPlaying() {
        if isSignOut == false{
            self.headerView.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.headerView.frame.size.height)
            self.headerView.setNeedsDisplay()
        }
       
       // print("ppppppppppppp>>>>>>>>>>>PPPPPPPPlayeeeerrrrrrrMethod")
    }
    
    func loadViewUIConstruct()  {
        SearchTxt.isEnabled = true
        SearchTxt.text = ""
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let generalVc = storyBoard.instantiateViewController(withIdentifier: "GeneralSafetyViewController") as! GeneralSafetyViewController
        generalVc.title = "General Safety"
        controllerArray.append(generalVc)
        let autoVc = storyBoard.instantiateViewController(withIdentifier: "AutoViewController") as! AutoViewController
        autoVc.title = "Auto"
        autoVc.delegate = self
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
            .MenuItemFont(UIFont.systemFont(ofSize: 12)),
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
    
    
    
    func loadDetailViewForToolBox(with value:String){
        signOutButton.isHidden = true
        backArrowImage.isHidden = false
        BackButton.isHidden = false
        self.urlStr = value
        self.loadDetailViewUIConstruct()
        hideBootomTab()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        backArrowImage.isHidden = true
        signOutButton.isHidden = false
        BackButton.isHidden = true
        self.pageMenu!.view.removeFromSuperview()
        controllerArray.removeAll()
        showBottomBar()
        loadViewUIConstruct()
        
        
    }
    
    
    func loadDetailViewUIConstruct()  {
        
        self.pageMenu!.view.removeFromSuperview()
        controllerArray.removeAll()
        SearchTxt.isEnabled = false
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let generalVc = storyBoard.instantiateViewController(withIdentifier: "GeneralSafetyViewController") as! GeneralSafetyViewController
        generalVc.title = "General Safety"
        controllerArray.append(generalVc)
        let autoVc = storyBoard.instantiateViewController(withIdentifier: "ToolBoxDetailViewController") as! ToolBoxDetailViewController
        autoVc.title = "Auto"
        autoVc.loadUrlStr = self.urlStr
        
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
    
    
    func hideBootomTab() {
        let customTBVc = self.tabBarController as! CustomTabBarViewController
        
        customTBVc.customTabBar.isHidden = true
    }
    
    func showBottomBar() {
        let customTBVc = self.tabBarController as! CustomTabBarViewController
        
        customTBVc.customTabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isSignOut = false
        // self.view.frame(CGRect(x:0,y:0,width:self.view.frame.size.width, height:self.view.frame.size.height))
        //self.view.frame = CGRect(x:0,y:100,width:self.view.frame.size.width, height:self.view.frame.size.height-100)
        // [self.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        self.view.setNeedsDisplay()
    }
    
    @IBAction func SignOutButtonPressed(_ sender: Any) {
        isSignOut = true
        for aview in self.view.subviews{
            aview.removeFromSuperview()
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let logInVc = storyBoard.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = logInVc
        
        
    }
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            search = String(search.characters.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        //self.delegate?.searchedWithValue(with: search)
        let vc = controllerArray[1] as! AutoViewController
        vc.searchedWithValue(with: search)
        
        print(search)
//        let predicate=NSPredicate(format: "SELF.name CONTAINS[cd] %@", search)
//        let arr=(AllData as NSArray).filtered(using: predicate)
//        
//        if arr.count > 0
//        {
//            SearchData.removeAll(keepingCapacity: true)
//            SearchData=arr as! Array<Dictionary<String,String>>
//        }
//        else
//        {
//            SearchData=AllData
//        }
//        ListTable.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableDidSelectCalled(){
        SearchTxt.resignFirstResponder()
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
