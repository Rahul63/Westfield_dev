//
//  UserDetailViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/17/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController,MiscellaneousServiceDelegate {
     weak var activeTextfield : UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    lazy var userUpdateService: MiscellaneousService = MiscellaneousService(delegate:self)
    
    private struct userKey {
        static let firstName = "firstName"
        static let lastName = "lastName"
    }
    
    private struct ServiceTypeConstants {
        static let lastName = "Smith"
        static let httpMethodGet = "GET"
        static let httpMethodPost = "POST"
        static let nName = "Jane"
        static let statusCodeOK = 200
    }

    @IBOutlet weak var profleImageView: UIImageView!
    @IBOutlet weak var policyNumberFld: UITextField!
    @IBOutlet weak var firstNameFld: UITextField!
    @IBOutlet weak var lastNameFld: UITextField!
    @IBOutlet weak var mobileNumFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    
    var userDataValue : [ProfileModel] = []
    var idValue = ""
    var isVoiceOn = "on"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications()
        
       // let UserIDv = UserDefaults.standard.value(forKey: "UserDetail") as! NSArray
        
        print("myUservalue\(userDataValue)")
        
        //if (self.userDataValue != nil) {
            
            let tempData = self.userDataValue[0]
            
            self.firstNameFld.text = tempData.firstName//self.userData
            //let dict = self.userData[0] as? Dictionary<String,AnyObject>
            self.lastNameFld.text = tempData.lastName
            self.policyNumberFld.text = tempData.policyNumber
            self.mobileNumFld.text = tempData.phoneNumber
            self.emailFld.text = tempData.email
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.deregisterFromKeyboardNotifications()
    }
    
    
    
       
    @IBAction func backButtonPressed(_ sender: Any) {
        self.firstNameFld.resignFirstResponder()
        self.lastNameFld.resignFirstResponder()
        self.mobileNumFld.resignFirstResponder()
        self.emailFld.resignFirstResponder()
        self.serviceCallUserUdate()
      // _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func helpButtonPressed(_ sender: Any) {
    }

    @IBAction func SelectImage(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func didReceiveMessage(withText text: Any){
        
        let newText = text as! Bool
        
        let isEqual = (newText == true)
        
        if isEqual {
            
            _ = self.navigationController?.popViewController(animated: true)
            
//            UserDefaults.standard.setValue(self.firstNameFld.text, forKey: "frstName")
//            UserDefaults.standard.setValue(self.lastNameFld, forKey: "lastName")
//            let alert = UIAlertController(title: "Info", message: "Updated Successfully", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Error", message: "Error occured while saving", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        
        
    }
    
    
    
    func serviceCallUserUdate()  {
        
        //userUpdateService.serviceCallforUserUpdate(withText:  self.firstNameFld.text!, and: self.lastNameFld.text!, and: self.idValue)
        userUpdateService.serviceCallforUserUpdate(withText: self.firstNameFld.text!, and: self.lastNameFld.text!, and: self.mobileNumFld.text!, and: self.emailFld.text!, and: self.idValue, and: isVoiceOn)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       // self.serviceCallforUserUpdate(withText: self.firstNameFld.text!, and: self.lastNameFld.text!)
        
        if textField==self.firstNameFld {
            self.lastNameFld.becomeFirstResponder()
        }
        else if textField == self.lastNameFld{
            self.mobileNumFld.becomeFirstResponder()
        }
        else if textField == self.mobileNumFld{
            self.emailFld.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        
        return true
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
