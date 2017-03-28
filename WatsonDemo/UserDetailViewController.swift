//
//  UserDetailViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/17/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController,MiscellaneousServiceDelegate {
    
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
       // }
        
//        let dict = UserIDv[0] as? Dictionary<String,AnyObject>
//        
//        
//        if ((self.userDataValue["preferredfirstname"]) != nil) {
//            self.firstNameFld.text = String(format: "%@ %@", (self.userDataValue["preferredfirstname"])!,"")//(self.userData["preferredlastname"])!)
//            self.lastNameFld.text = self.userDataValue["preferredlastname"]
//        }
//        
//        if ((self.userDataValue["policynumber"]) != nil) {
//            self.policyNumberFld.text = String(format: "Policy : %@", (self.userDataValue["policynumber"])!)
//        }
//        if ((self.userDataValue["cellphonenumber"]) != nil) {
//            self.mobileNumFld.text = self.userDataValue["cellphonenumber"]!
//        }
//        if ((self.userDataValue["email"]) != nil) {
//            self.emailFld.text  = self.userDataValue["email"]!
//        }
        
//        if ((dict?["preferredfirstname"] as? String) != nil) {
//            self.firstNameFld.text =   dict?["preferredfirstname"] as? String!
//            self.lastNameFld.text =   dict?["preferredlastname"] as? String!
//        }
//        
//        
//         self.mobileNumFld.text =   dict?["cellphonenumber"] as? String!
//         self.emailFld.text =   dict?["email"] as? String!
//         self.policyNumberFld.text =   dict?["policynumber"] as? String!
        //self.idValue = (dict?["_id"] as? String!)!
        
//        self.navigationController?.navigationBar.isHidden = false

        // Do any additional setup after loading the view.
    }
    
    
    
       
    @IBAction func backButtonPressed(_ sender: Any) {
        self.firstNameFld.resignFirstResponder()
        self.lastNameFld.resignFirstResponder()
        self.mobileNumFld.resignFirstResponder()
        self.emailFld.resignFirstResponder()
       _ = self.navigationController?.popViewController(animated: true)
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
    
    
    func serviceCallforUserUpdate(withText firstName: String,and lastName:String) {
        print("Send Msg called")
        
        print("Send Msg called with text..\(firstName,lastName)")
        
        
        let requestParameters =
            [userKey.firstName: firstName,
             userKey.firstName: lastName]
        
        
        print("Send Msg called with Request.Para.\(requestParameters)")
        var request = URLRequest(url: URL(string: GlobalConstants.userDetailUpdateUrl)!)
        
        request.httpMethod = "POST"//ServiceTypeConstants.httpMethodPost
        request.httpBody = requestParameters.stringFromHttpParameters().data(using: .utf8)
        
        print("Send Msg called with BODYYYYYYYYY>>>>>>>>>>.\(requestParameters.stringFromHttpParameters())")
        
        print("Send Msg called with request Body..\(request)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for fundamental networking error
            DispatchQueue.main.async { [weak self] in
                
                guard let data = data, error == nil else {
                    print("error=\(error)")
                    return
                }
                
                // check for http errors
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != ServiceTypeConstants.statusCodeOK {
                    print("Failed with status code: \(httpStatus.statusCode)")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                if let data = responseString?.data(using: String.Encoding.utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                            print("JSON Value...\(json)")
                            //self?.parseJson(json: json)
                        }
                    } catch {
                        // No-op
                    }
                    
                }
            }
        }
        
        /// Delay conversation request so as to give the keyboard time to dismiss and chat table view to scroll bottom
        let when = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when + 0.3) {
            task.resume()
        }
        
    }
    
    func serviceCallUserUdate()  {
        
        //userUpdateService.serviceCallforUserUpdate(withText:  self.firstNameFld.text!, and: self.lastNameFld.text!, and: self.idValue)
        userUpdateService.serviceCallforUserUpdate(withText: self.firstNameFld.text!, and: self.lastNameFld.text!, and: self.mobileNumFld.text!, and: self.emailFld.text!, and: self.idValue, and: isVoiceOn)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       // self.serviceCallforUserUpdate(withText: self.firstNameFld.text!, and: self.lastNameFld.text!)
        self.serviceCallUserUdate()
        self.firstNameFld.resignFirstResponder()
        self.lastNameFld.resignFirstResponder()
        self.mobileNumFld.resignFirstResponder()
        self.emailFld.resignFirstResponder()
        self.policyNumberFld.resignFirstResponder()
        return true
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
