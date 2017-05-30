//
//  AddDistViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/24/17.
//  Copyright © 2017 RAHUL. All rights reserved.
//

import UIKit

class AddDistViewController: UIViewController {
    
    @IBOutlet weak var firstNameFld: UITextField!
    @IBOutlet weak var lastNameFld: UITextField!
    @IBOutlet weak var mobileNumFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    var distListData: NSMutableArray = []
    var newData = [String: String]()
    var idValue = ""
    var revValue = ""
    var idDvalue = ""
    
    private struct KeyValue {
        static let firstname  = "firstname"
        static let lastname  = "lastname"
        static let cellphone = "cellphone"
        static let email = "email"
        static let id = "_id"
        static let distributionList = "distributionlist"
        static let revValue = "_rev"
        static let type = "type"
        
    }
    
    private struct ServiceTypeConstants {
        static let httpMethodPut = "PUT"
        static let statusCodeOK = 200
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstNameFld.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newData = [KeyValue.firstname:self.firstNameFld.text!,KeyValue.lastname:self.lastNameFld.text!,KeyValue.cellphone: self.mobileNumFld.text!,KeyValue.email:self.emailFld.text!]
        distListData.add(newData)
        print("new data list..\(distListData)")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: distListData, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        //Convert back to string. Usually only do this for debugging
        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
            print(JSONString)
            
            let bodyParameter = [KeyValue.distributionList: distListData]
            
            if let json = try? JSONSerialization.data(withJSONObject: bodyParameter, options: []) {
                if let content = String(data: json, encoding: String.Encoding.utf8) {
                    // here `content` is the JSON dictionary containing the String
                    self.serviceCallforSaveDistributionList(with: content)
                    print(content)
                }
            }
            
//            let jsonDataNew = try! JSONSerialization.data(withJSONObject: bodyParameter, options: JSONSerialization.WritingOptions.prettyPrinted)
//            
//            if let JSONStringNew = String(data: jsonDataNew, encoding: String.Encoding.utf8) {
//                print(JSONStringNew)
//                self.serviceCallforSaveDistributionList(with: JSONStringNew)
//            }
            
        }
        
        
        // self.serviceCallforUserUpdate(withText: self.firstNameFld.text!, and: self.lastNameFld.text!)
        self.firstNameFld.resignFirstResponder()
        self.lastNameFld.resignFirstResponder()
        self.mobileNumFld.resignFirstResponder()
        self.emailFld.resignFirstResponder()
        return true
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.firstNameFld.resignFirstResponder()
        self.lastNameFld.resignFirstResponder()
        self.mobileNumFld.resignFirstResponder()
        self.emailFld.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
       
    }
    
    
    //“{"_id": "1","_rev": "1-d9a9a0f61341996261066f94c7164748","type": "distributionlist","distributionlist": [{"firstname": "employee1frstname","lastname": "employee1lasttname","cellphone": "234-555-6767","email": "gsdgs@sjfsfj.com"},{"firstname": "employee2frstname","lastname": "employee2lastname","cellphone": "234-333-62427","email": "111@56ms.com"}]}”
    
    
    func serviceCallforSaveDistributionList(with list:String) {

//        var listN = list.replacingOccurrences(of: "\n", with: "")
//        listN = list.replacingOccurrences(of: " ", with: "")
//        listN = list.replacingOccurrences(of: "\\", with: "")
        
        let requestParametersNew =
                    [KeyValue.id: idValue,
                     KeyValue.distributionList : list]
        
        print("Send Msg called with Request.Para.\(requestParametersNew)")
        var request2 = URLRequest(url: URL(string: GlobalConstants.updateDistributionList)!)
        request2.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request2.httpMethod = ServiceTypeConstants.httpMethodPut
        request2.httpBody = requestParametersNew.stringFromHttpParameters().data(using: .utf8)
        let taskUser = URLSession.shared.dataTask(with: request2) { data, response, error in
            // check for fundamental networking error
            DispatchQueue.main.async { [weak self] in
                guard let data = data, error == nil else {
                    print("error=\(error)")
                    return
                    
                }
                // check for http errors
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode !=
                    ServiceTypeConstants.statusCodeOK {
                    print("Failed with status code: \(httpStatus.statusCode)")
                }
                let responseString = String(data: data, encoding: .utf8)
                
                if let data = responseString?.data(using: String.Encoding.utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                            print("JSON Value..DISTRIBUTION.")
                            self?.responseFromServer(with: json)
                        }
                        
                    } catch {
                        // No-op
                    }
                }
            }
            
        }
        let when2 = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when2 + 0.3) {
            taskUser.resume()
            
        }

        
     }
 
    
    func responseFromServer(with json: [String:AnyObject]) {
        print(json)
        let text = json["ok"] as! Bool
        let isEqual = (text == true)
        
        if isEqual {
            self.dismiss(animated: true, completion: nil)
            
            //_ = self.navigationController?.popViewController(animated: true)
        
        }else{
            let alert = UIAlertController(title: "Error", message: "Error occured while saving", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
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
