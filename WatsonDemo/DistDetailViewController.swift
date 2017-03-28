//
//  DistDetailViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/24/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class DistDetailViewController: UIViewController {

    @IBOutlet weak var firstNameFld: UITextField!
    @IBOutlet weak var lastNameFld: UITextField!
    @IBOutlet weak var mobileNumFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    var distributionData = ["":""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.firstNameFld.resignFirstResponder()
        self.lastNameFld.resignFirstResponder()
        self.mobileNumFld.resignFirstResponder()
        self.emailFld.resignFirstResponder()
        self.backButtonPressed("")
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
