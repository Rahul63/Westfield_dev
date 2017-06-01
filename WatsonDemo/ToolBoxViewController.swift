//
//  ToolBoxViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/3/17.
//  Copyright © 2017 RAHUL. All rights reserved.
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.headerView.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.headerView.frame.size.height)
        self.headerView.setNeedsDisplay()
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.playerDidFinishPlaying),name:NSNotification.Name.UIWindowDidBecomeHidden,object:nil)
        
        self.loadViewUIConstruct()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.SearchTxt.text = ""
    }
    
    
    func playerDidFinishPlaying() {
        if isSignOut == false{
            self.headerView.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.headerView.frame.size.height)
            self.headerView.setNeedsDisplay()
        }
       
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
