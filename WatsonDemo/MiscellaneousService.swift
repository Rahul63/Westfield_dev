//
//  MiscellaneousService.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/22/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import Foundation

protocol MiscellaneousServiceDelegate: class {
    func didReceiveMessage(withText text: Any)
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
        static let nName = "Jane"
        static let statusCodeOK = 200
    }
    
    // MARK: - Key
    private struct BodyKey {
        static let username = "username"
        static let password = "password"
    }
    
    
    init(delegate: MiscellaneousServiceDelegate) {
        self.delegate = delegate
    }
    
    func serviceCallforLogin(withText textUser: String,and textPassword:String) {
        print("Send Msg called")
       
        print("Send Msg called with text..\(textUser,textPassword)")
        
        
        let requestParameters =
            [BodyKey.username: textUser,
             BodyKey.password: textPassword
        ]
        
        
        print("Send Msg called with Request.Para.\(requestParameters)")
        var request = URLRequest(url: URL(string: GlobalConstants.logInAuthenticationUrl)!)
        
        request.httpMethod = ServiceTypeConstants.httpMethodPost
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
    
    func parseJson(json: [String:AnyObject]) {
        
        //self.value = json["docs"] as! [String]
        let text = json["docs"] as! NSArray
        
        // Look for the option params in the brackets
//        let nsString = text as NSString
//        let regex = try! NSRegularExpression(pattern: "wcs:input>")
//        var options: [String]?
//        if let result = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length)).last {
//            var optionsString = nsString.substring(with: result.range)
//            text = text.replacingOccurrences(of: optionsString, with: "")
//            optionsString = optionsString.replacingOccurrences(of: "[", with: "")
//            optionsString = optionsString.replacingOccurrences(of: "]", with: "")
//            optionsString = optionsString.replacingOccurrences(of: ", ", with: ",")
//            options = optionsString.components(separatedBy: ",")
//        }
        

        self.delegate?.didReceiveMessage(withText:text)
        
    }

    
    
    
    
    

}
