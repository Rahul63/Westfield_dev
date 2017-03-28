//
//  DistributionListService.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/23/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import Foundation

protocol DistributionServiceDelegate: class {
    func didReceiveDistributionList(withText text: Any, andId Id:String, andRev rev : String )
}

class DistributionListService {
    
        weak var delegate: DistributionServiceDelegate?
        var value: [String] = []
        var firstName: String?
    
        var revValue: String?
        var idDvalue: String?
        
    
    
    private struct BodyKeyDist {
        static let firstname = "firstname"
        static let lastname = "lastname"
        static let cellphone  = "cellphone"
        static let email  = "email"
        static let id = "id"
    }
        private struct ServiceTypeConstants {
            static let lastName = "Smith"
            static let httpMethodGet = "GET"
            static let httpMethodPost = "POST"
            static let nName = "Jane"
            static let statusCodeOK = 200
        }
        
        init(delegate: DistributionServiceDelegate) {
            self.delegate = delegate
        }
    
        
    func serviceCallforDistributionList(With id:String) {
         let urlStr = String(format: GlobalConstants.getDistributionList, id)
        print("Send Msg called")
        var request2 = URLRequest(url: URL(string: urlStr)!)
        request2.httpMethod = ServiceTypeConstants.httpMethodGet
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
                            self?.parseJsonDist(json: json)
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
    
    //“{"_id": "1","_rev": "1-d9a9a0f61341996261066f94c7164748","type": "distributionlist","distributionlist": [{"firstname": "employee1frstname","lastname": "employee1lasttname","cellphone": "234-555-6767","email": "gsdgs@sjfsfj.com"},{"firstname": "employee2frstname","lastname": "employee2lastname","cellphone": "234-333-62427","email": "111@56ms.com"}]}”
    
    
  /*  func serviceCallforSaveDistributionList(With id:String) {
        let requestParametersNew //=
//            [BodyKey.preferredfirstname: firstName,
//             BodyKey.preferredlastname: lastName,
//             BodyKey.id : Id
//        ]
        print("Send Msg called with Request.Para.\(requestParametersNew)")
        var request2 = URLRequest(url: URL(string: GlobalConstants.updateDistributionList)!)
        
        request2.httpMethod = ServiceTypeConstants.httpMethodPost
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
                            //self?.parseJsonDist(json: json)
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
    */

    
    func parseJsonDist(json: [String:AnyObject]) {
        
        let text = json["distributionlist"] as! NSArray
        idDvalue = json["_id"] as! String?
        revValue = json["_rev"] as! String?
        //print(text)
        
        self.delegate?.didReceiveDistributionList(withText: text, andId: idDvalue!, andRev: revValue!)
        
    }

    

}




