//
//  UserViewCell.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/15/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

protocol userCellDelegate
{
    func emailAddressIsNotValid()
    func nameFieldIsEmpty()
}


class UserViewCell: UITableViewCell,MiscellaneousServiceDelegate,UITextFieldDelegate {
//    @IBOutlet weak var fullNameLbl: UILabel!
//    @IBOutlet weak var phoneLbl: UILabel!
//    @IBOutlet weak var policyNumLbl: UILabel!
//    @IBOutlet weak var emailLbl: UILabel!
//    @IBOutlet weak var firstNameLbl: UILabel!
//    @IBOutlet weak var userImageVw: UIImageView!
    
    var delegate: userCellDelegate!
    weak var activeTextfield : UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    lazy var userUpdateService: MiscellaneousService = MiscellaneousService(delegate:self as MiscellaneousServiceDelegate)
    
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mobileNumFld.delegate = self
        self.deregisterFromKeyboardNotifications()
        self.registerForKeyboardNotifications()
        //
    }

    
    
    func didReceiveMessage(withText text: Any){
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
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height-120, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.frame
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
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height-120, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.endEditing(true)
        self.scrollView.isScrollEnabled = false
        if self.firstNameFld.text != ""  || self.firstNameFld.text != " "{
            deregisterFromKeyboardNotifications()
            serviceCallUserUdate()
            
        }else{
            delegate.nameFieldIsEmpty()
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextfield = textField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeTextfield = nil
        
        if textField == self.emailFld{
            let valid = self.isValidEmail(testStr: self.emailFld.text!)
            if !valid{
                self.emailFld.text = ""
                delegate.emailAddressIsNotValid()
                
            }
            
        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.mobileNumFld{
            let charsLimit = 12
            
            let startingLength = textField.text?.characters.count ?? 0
            let lengthToAdd = string.characters.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            //self.mobileNumFld.text = numberFiltered
            print(numberFiltered)
            if ((textField.text?.characters.count == 3 )||( textField.text?.characters.count == 7)) {
                if (string != "") {
                    textField.text = textField.text?.appending("-")
                }
            }
           
            print(string)
            if newLength > charsLimit{
                return false
                //return string == numberFiltered
            }else{
               // return false
                return string == numberFiltered
            }
            
            
            //return newLength <= charsLimit
        }
        else if textField == self.firstNameFld{
            if (string == " ") {
                return false
            }else{
                return true
            }
        }
        else{
            return true
        }        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
