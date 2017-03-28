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
    
    let button = KGRadioButton(frame: CGRect(x: 20, y: 170, width: 25, height: 25))
    let label2 = UILabel(frame: CGRect(x: 90, y: 160, width: 200, height: 70))
    
    var logIndata : NSArray = []
    //var userValue = []()
    
    lazy var logInService: MiscellaneousService = MiscellaneousService(delegate:self)
    
    // var logInService = MiscellaneousService(delegate: MiscellaneousServiceDelegate.self as! MiscellaneousServiceDelegate) //= MiscellaneousService(delegate:self as! MiscellaneousServiceDelegate)

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        button.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
//        button.outerCircleColor = UIColor.red
//        self.view.addSubview(button)
//        label2.text = "Not Selected"
//        self.view.addSubview(label2)
        
//         userValue = UserDefaults.standard.value(forKey: "UserDetail") as? NSArray
//        if userValue.count>0 {
           //self.logInUser()
//        }
        
        self.signInButton.layer.cornerRadius = 3.0
        self.view.backgroundColor = UIColor(netHex:0xd89c54)

        self.userNameField.text = "a"
        self.passwordField.text = "b"
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
        self.userNameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        return true
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
