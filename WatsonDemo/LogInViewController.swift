//
//  LogInViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/10/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController,MiscellaneousServiceDelegate{
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activeTextfield : UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    let button = KGRadioButton(frame: CGRect(x: 20, y: 170, width: 25, height: 25))
    let label2 = UILabel(frame: CGRect(x: 90, y: 160, width: 200, height: 70))
    let sharedInstnce = watsonSingleton.sharedInstance
    var logIndata : NSArray = []
    //var userValue = []()
    
    lazy var logInService: MiscellaneousService = MiscellaneousService(delegate:self)
    
    // var logInService = MiscellaneousService(delegate: MiscellaneousServiceDelegate.self as! MiscellaneousServiceDelegate) //= MiscellaneousService(delegate:self as! MiscellaneousServiceDelegate)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications()
       // NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
//        button.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
//        button.outerCircleColor = UIColor.red
//        self.view.addSubview(button)
//        label2.text = "Not Selected"
//        self.view.addSubview(label2)
        
//         userValue = UserDefaults.standard.value(forKey: "UserDetail") as? NSArray
//        if userValue.count>0 {
          // self.logInUser()
//        }
        
        self.signInButton.layer.cornerRadius = 3.0
        self.view.backgroundColor = UIColor(netHex:0xd89c54)

//        self.userNameField.text = "a"
//        self.passwordField.text = "b"
        // Do any additional setup after loading the view.
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
        print("viewDisapper call>>>>>>")
        super.viewDidDisappear(animated)
        self.deregisterFromKeyboardNotifications()
    }
    
    
    
    @IBAction func SignButtonPressed(_ sender: Any) {
        
        if self.userNameField.text == "" && self.passwordField.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Username/Password should not be empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            
            self.validateSigningUser(userName: self.userNameField.text!, password: self.passwordField.text!)
            
        }
        
    }
    
    func validateSigningUser(userName:String, password:String) {
        logInService.serviceCallforLogin(withText: userName, and: password)
    }
    
    func didReceiveMessage(withText text: Any){
        
        print("myValue>>>\(text)")
        self.logIndata = text as! NSArray
        
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
        let alert = UIAlertController(title: "Error", message: "The username or password you entered is not correct.  Please try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logInUser() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let BaseTabVc = storyBoard.instantiateViewController(withIdentifier: "tabbarVC") as! UITabBarController
        // UITabBar.appearance().tintColor = UIColor.lightGrayColor()
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
    
    
    
    
    
    
//    func keyboardNotification(notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
//            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
//            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
//            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
//            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
//                self.keyboardHeightLayoutConstraint?.constant = 0.0
//            } else {
//                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
//            }
//            UIView.animate(withDuration: duration,
//                           delay: TimeInterval(0),
//                           options: animationCurve,
//                           animations: { self.view.layoutIfNeeded() },
//                           completion: nil)
//        }
//    }
    
    
//    func keyboardWillShow(notification: NSNotification) {
//        
//       // let userInfo: [NSObject : AnyObject] = notification.userInfo! as [NSObject : AnyObject]
//        
//        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
//        
//        //let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
//        let offset = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//        
//        if keyboardSize?.height == offset?.height {
//            UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                self.view.frame.origin.y += (keyboardSize?.height)!
//            })
//        } else {
//            UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                self.view.frame.origin.y -= (keyboardSize?.height)! - (offset?.height)!
//            })
//        }
//        var translation:CGFloat = 0
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
////            if detailsField.isEditing{
////                translation = CGFloat(-keyboardSize.height)
////            }else if priceField.isEditing{
////                translation = CGFloat(-keyboardSize.height / 3.8)
////            }
//        }
//        UIView.animate(withDuration: 0.2) {
//            self.view.transform = CGAffineTransform(translationX: 0, y: translation)
//        }
    }
    
//    
//    func keyboardWillHide(notification: NSNotification) {
//        UIView.animate(withDuration: 0.2) {
//            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
//        } 
//    }
//    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */













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
