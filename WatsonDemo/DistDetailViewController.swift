//
//  DistDetailViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/24/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class DistDetailViewController: UIViewController {

     weak var activeTextfield : UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameFld: UITextField!
    @IBOutlet weak var lastNameFld: UITextField!
    @IBOutlet weak var mobileNumFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    var distributionData = ["":""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications()
        print(distributionData)

        if ((self.distributionData["firstname"]) != nil) {
            self.firstNameFld.text = String(format: "%@ %@", (self.distributionData["firstname"])!,"")//(self.userData["preferredlastname"])!)
            self.lastNameFld.text = self.distributionData["lastname"]
        }
        
       
        if ((self.distributionData["cellphone"]) != nil) {
            self.mobileNumFld.text = self.distributionData["cellphone"]!
        }
        if ((self.distributionData["email"]) != nil) {
            self.emailFld.text  = self.distributionData["email"]!
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.deregisterFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.firstNameFld.resignFirstResponder()
        self.lastNameFld.resignFirstResponder()
        self.mobileNumFld.resignFirstResponder()
        self.emailFld.resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // self.serviceCallforUserUpdate(withText: self.firstNameFld.text!, and: self.lastNameFld.text!)
       // self.serviceCallUserUdate()
        
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
        
        //self.backButtonPressed("")
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
