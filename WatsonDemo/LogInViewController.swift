//
//  LogInViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/10/17.
//  Copyright © 2017 RAHUL. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController,MiscellaneousServiceDelegate{
    var  indicatorView = ActivityView()
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activeTextfield : UITextField!
    var timerTest : Timer?
    @IBOutlet weak var scrollView: UIScrollView!
    let button = KGRadioButton(frame: CGRect(x: 20, y: 170, width: 25, height: 25))
    let label2 = UILabel(frame: CGRect(x: 90, y: 160, width: 200, height: 70))
    let sharedInstnce = watsonSingleton.sharedInstance
    var logIndata : NSArray = []
    //var userValue = []()
    
    lazy var logInService: MiscellaneousService = MiscellaneousService(delegate:self)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        //self.logInUser()
        self.registerForKeyboardNotifications()
        self.signInButton.layer.cornerRadius = 3.0
        self.view.backgroundColor = UIColor(netHex:0xd89c54)

    }
    
    func manualAction (sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            label2.text = "Selected"
        } else{
            label2.text = "Not Selected"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.deregisterFromKeyboardNotifications()
    }
    
    
    
    @IBAction func SignButtonPressed(_ sender: Any) {
        
        if self.userNameField.text == "" || self.passwordField.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Username/Password should not be empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            
            let isConnectedNetwork = networkConnection()
            let connected = isConnectedNetwork.isInternetAvailable()
            
            if connected{
                self.validateSigningUser(userName: self.userNameField.text!, password: self.passwordField.text!)
            }else{
                logInNetworkError()
            }
            
        }
        
    }
    
    func validateSigningUser(userName:String, password:String) {
        StartAnimating()
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
        self.userNameField.isEnabled = false
        self.passwordField.isEnabled = false
        timerTest = Timer.scheduledTimer(timeInterval: 45.0, target: self, selector: #selector(enableLogIn), userInfo: nil, repeats: false)
        //signInButton.backgroundColor = UIColor.gray
        logInService.serviceCallforLogin(withText: userName, and: password)
    }
    
    func didReceiveMessage(withText text: Any){
        stopAnimating()
        if timerTest != nil {
            timerTest?.invalidate()
            timerTest = nil
        }
        print("myValue>>>\(text)")
        
        if let logIndata = text as? NSArray{
            self.logIndata = logIndata
        }
        
       // self.logIndata = text as? NSArray
        
       // guard let count = self.logIndata.count else { return <#return value#> }
        
        if self.logIndata.count>0{
            UserDefaults.standard.setValue(self.logIndata, forKey: "UserDetail")
            
            let dict2 = self.logIndata[0] as? Dictionary<String,AnyObject>
            
            let voiceVal = (dict2?["voice"] as? String!)!
            
            print(voiceVal ?? "")
            
            if (voiceVal == "on") {
                sharedInstnce.isVoiceOn = true
            }else{
                sharedInstnce.isVoiceOn = false
            }
            
            self.logInUser()
        }else{
            self.logInError()
        }
        
    }
    
    
    func logInError() {
        signInButton.isEnabled = true
        self.userNameField.isEnabled = true
        self.passwordField.isEnabled = true
        signInButton.alpha = 1.0
        let alert = UIAlertController(title: "Error", message: "The username or password you entered is not correct. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logInNetworkError() {
        let alert = UIAlertController(title: "Error", message: "Network is not available. Please try again once connected to network.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logInUser() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let BaseTabVc = storyBoard.instantiateViewController(withIdentifier: "tabbarVC") as! UITabBarController
        UITabBar.appearance().barTintColor = UIColor(netHex:0xd89c54)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blue], for:.selected)
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.normal)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = BaseTabVc
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // self.userNameField.resignFirstResponder()
        
        if textField==self.userNameField {
            self.passwordField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        //
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeTextfield {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextfield = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeTextfield = nil
    }
    
    func enableLogIn() {
        stopAnimating()
        signInButton.isEnabled = true
        signInButton.alpha = 1.0
        self.userNameField.isEnabled = true
        self.passwordField.isEnabled = true
        let alert = UIAlertController(title: "Error", message: "Session expired, please try again", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func StartAnimating() {
        
        indicatorView.frame = CGRect(x:0,y:0,width:50,height:50)
        indicatorView.center = self.view.center//CGPoint(x:self.view.center,y:self.view)
        indicatorView.lineWidth = 5.0
        indicatorView.strokeColor = UIColor(red: 0.0/255, green: 122.0/255, blue: 255.0/255, alpha: 1)
        self.view.addSubview(indicatorView)
        indicatorView.startAnimating()
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    func stopAnimating() {
        signInButton.isEnabled = true
        signInButton.alpha = 1.0
        indicatorView.stopAnimating()
        indicatorView.hidesWhenStopped = true
        indicatorView.removeFromSuperview()
        
        
    }
    

}
    


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
