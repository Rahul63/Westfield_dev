//
//  MiscellaneousService.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/22/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import Foundation

@objc protocol MiscellaneousServiceDelegate: class {
    func didReceiveMessage(withText text: Any)
    @objc optional func didReceiveProfile(withText text: NSMutableArray)
    //optional func didReceiveProfile(withText text: NSMutableArray)
}

class MiscellaneousService {
    
    weak var delegate: MiscellaneousServiceDelegate?
    //var value = [Dictionary]
    
    var value: [String] = []
    var firstName: String?
    
    
    private struct ServiceTypeConstants {
        static let lastName = "Smith"
        static let httpMethodGet = "GET"
        static let httpMethodPost = "POST"
        static let httpMethodPut = "PUT"
        static let nName = "Jane"
        static let statusCodeOK = 200
    }
    
    // MARK: - Key
    private struct BodyKey {
        static let username = "username"
        static let password = "password"
        static let preferredfirstname  = "preferredfirstname"
        static let preferredlastname  = "preferredlastname"
        static let cellphonenumber = "cellphonenumber"
        static let email = "email"
        static let id = "id"
        static let voice = "voice"
    }
    
    
    init(delegate: MiscellaneousServiceDelegate) {
        self.delegate = delegate
    }
    
    
    
    
    
    
    func serviceCallforUserUpdate(withText firstName: String,and lastName:String, and phone:String, and email:String, and Id: String, and voice : String) {
        print("Send Msg called")
        
        print("Send Msg called with text..\(firstName,lastName,Id)")
        
        var finalContent : String!
        
        let requestParametersNew =
            [BodyKey.preferredfirstname: firstName,
             BodyKey.preferredlastname: lastName,
             BodyKey.cellphonenumber : phone,
             BodyKey.email : email,
             BodyKey.id : Id,
             BodyKey.voice : voice
        ]
        
        if let json = try? JSONSerialization.data(withJSONObject: requestParametersNew, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                print(content)
                finalContent = content
                
                var request2 = URLRequest(url: URL(string: GlobalConstants.userDetailUpdateUrl)!)
                
                request2.httpMethod = ServiceTypeConstants.httpMethodPut
                request2.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request2.httpBody = requestParametersNew.stringFromHttpParameters().data(using: .utf8)
                let taskUser = URLSession.shared.dataTask(with: request2) { data, response, error in
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
                                    print("JSON Value...Update User")
                                    self?.parseJsonUser(json: json)
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
        }
        print("Send Msg called with Request.Para.\(finalContent!)")
        
        
    }
    
    
    
    
    func serviceCallforLogin(withText textUser: String,and textPassword:String) {
        print("Send Msg called")
       
       // print("Send Msg called with text..\(textUser,textPassword)")
        
        
        let requestParameters =
            [BodyKey.username: textUser,
             BodyKey.password: textPassword
        ]
        
        var request = URLRequest(url: URL(string: GlobalConstants.logInAuthenticationUrl)!)
        request.httpMethod = ServiceTypeConstants.httpMethodPost
        request.httpBody = requestParameters.stringFromHttpParameters().data(using: .utf8)
        
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
                            print("JSON Value.LogIn..\(json)")
                            self?.parseJson(json: json)
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
    

    
    func serviceCallforGettingProfile(With id:String) {
        
        print("Send Msg called")
        
        let urlStr = String(format: GlobalConstants.getProfileData, id)
        
        var request3 = URLRequest(url: URL(string: urlStr)!)
        request3.httpMethod = "GET"//ServiceTypeConstants.httpMethodGet
        //print("Send Msg called with request Body..\(request3)")
        let taskUser = URLSession.shared.dataTask(with: request3) { data, response, error in
            // check for fundamental networking error
            DispatchQueue.main.async { [weak self] in
                guard let data = data, error == nil else {
                    print("error=\(error)")
                    return
                    
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode !=
                    ServiceTypeConstants.statusCodeOK {
                    //print("Failed with status code: \(httpStatus.statusCode)")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                if let data = responseString?.data(using: String.Encoding.utf8) {
                    
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                            print("JSON Value.For profile..")
                            
                            //let jsonData = json as! [[String:AnyObject]]
                            
                            //let completeData = (jsonData as AnyObject).mutableCopy()
                            
                            self?.parseJsonProfile(json: json)
                        }
                        
                    } catch {
                        
                    }
                    
                }
            }
        }
        let when2 = DispatchTime.now()
        
        DispatchQueue.main.asyncAfter(deadline: when2 + 0.3) {
            
            taskUser.resume()
            
        }
        
        
    }
    
    
    
    
    
    func parseJsonProfile(json: [String:AnyObject]) {
        
        //self.value = json["docs"] as! [String]
            let text = (json)
         self.delegate?.didReceiveMessage(withText: text)
        
    }
    
    
    
    
    func parseJson(json: [String:AnyObject]) {
        
        //self.value = json["docs"] as! [String]
        let text = json["docs"] as? NSArray
        self.delegate?.didReceiveMessage(withText:text ?? "")
        
    }
    
    func parseJsonUser(json: [String:AnyObject]) {
        print(json)
        if let text = json["ok"] as? Bool{
            self.delegate?.didReceiveMessage(withText:text)
        }else{
            self.delegate?.didReceiveMessage(withText:false)
        }
        //self.value = json["docs"] as! [String]
//        let text = json["docs"] as! NSArray
        
        
    }

    
    
    
    
    

}
