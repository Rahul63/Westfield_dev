//
//  ConversationService.swift
//  WatsonDemo
//
//  Created by Etay Luz on 11/15/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

import Foundation

protocol ConversationServiceDelegate: class {
    func didReceiveMessage(withText text: String, options: [String]?)
    func didReceiveMap(withUrl mapUrl: URL)
    func didReceiveVideo(withUrl videoUrl: URL)
}


class ConversationService {

    // MARK: - Properties
    weak var delegate: ConversationServiceDelegate?
    var context = ""
    var firstName: String?
    var value1: String?
    var value2: String?
    var value3: String?

    // MARK: - Constants
    private struct Constants {
        static let lastName = "Smith"
        static let httpMethodGet = "GET"
        static let httpMethodPost = "POST"
        static let nName = "Jane"
        static let statusCodeOK = 200
    }

    // MARK: - Key
    private struct Key {
        static let context = "context"
        static let cValue1 = "cvalue1"
        static let cValue2 = "cvalue2"
        static let cValue3 = "cvalue3"
        static let input = "input"
        static let firstName = "fname"
        static let lastName = "lname"
        static let nName = "nname"
        static let workspaceID = "workspace_id"
    }

    // MARK: - Map
    private struct Map {
        static let mapOne = "https://maps.googleapis.com/maps/api/staticmap?format=png&zoom=17&size=590x300&markers=icon:http://chart.apis.google.com/chart?chst=d_map_pin_icon%26chld=cafe%257C996600%7C10900+South+Parker+road+Parker+Colorado&key=AIzaSyA22GwDjEAwd58byf7JRxcQ5X0IK6JlT9k"
        static let mapTwo = "https://maps.googleapis.com/maps/api/staticmap?maptype=satellite&format=png&zoom=18&size=590x300&markers=icon:http://chart.apis.google.com/chart?chst=d_map_pin_icon%26chld=cafe%257C996600%7C10900+South+Parker+road+Parker+Colorado&key=AIzaSyA22GwDjEAwd58byf7JRxcQ5X0IK6JlT9k"
        static let mapThree = "https://maps.googleapis.com/maps/api/staticmap?format=png&zoom=13&size=590x300&markers=icon:http://chart.apis.google.com/chart?chst=d_map_pin_icon%26chld=cafe%257C996600%7C1000+Jasper+Avenue+Edmonton+Canada&key=AIzaSyA22GwDjEAwd58byf7JRxcQ5X0IK6JlT9k"
        static let mapFour = "https://maps.googleapis.com/maps/api/staticmap?maptype=satellite&format=png&zoom=18&size=590x300&markers=icon:http://chart.apis.google.com/chart?chst=d_map_pin_icon%26chld=cafe%257C996600%7C1000+Jasper+Avenue+Edmonton+Canada&key=AIzaSyA22GwDjEAwd58byf7JRxcQ5X0IK6JlT9k"
    }

    private struct Video {
        static let videoOne = Bundle.main.path(forResource: "Movie1", ofType:"mp4")!
        static let videoTwo = Bundle.main.path(forResource: "Movie2", ofType:"mp4")!
    }

    // MARK: - Init
    init(delegate: ConversationServiceDelegate) {
        self.delegate = delegate
    }

    func sendMessage(withText text: String) {
        if firstName == nil && text != "Hi" {
            firstName = text
        }

        let requestParameters =
            [Key.input: text,
             Key.workspaceID: GlobalConstants.sriniCheedallaWorkspaceID,
             Key.firstName: firstName,
             Key.lastName: Constants.lastName,
             Key.nName: Constants.nName,
             Key.cValue1: value1,
             Key.cValue2: value2,
             Key.cValue3: value3,
             Key.context: context
        ]

        var request = URLRequest(url: URL(string: GlobalConstants.sriniCheedallNodeRedWorkflowUrl)!)
        request.httpMethod = Constants.httpMethodPost
        request.httpBody = requestParameters.stringFromHttpParameters().data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for fundamental networking error
            DispatchQueue.main.async { [weak self] in

                guard let data = data, error == nil else {
                    print("error=\(error)")
                    return
                }

                // check for http errors
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != Constants.statusCodeOK {
                    print("Failed with status code: \(httpStatus.statusCode)")
                }

                let responseString = String(data: data, encoding: .utf8)
                if let data = responseString?.data(using: String.Encoding.utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
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

        self.context = json["context"] as! String
        var text = json["text"] as! String

        // Look for the option params in the brackets
        let nsString = text as NSString
        let regex = try! NSRegularExpression(pattern: "\\[.*\\]")
        var options: [String]?
        if let result = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length)).last {
            var optionsString = nsString.substring(with: result.range)
            text = text.replacingOccurrences(of: optionsString, with: "")
            optionsString = optionsString.replacingOccurrences(of: "[", with: "")
            optionsString = optionsString.replacingOccurrences(of: "]", with: "")
            optionsString = optionsString.replacingOccurrences(of: ", ", with: ",")
            options = optionsString.components(separatedBy: ",")
        }

        #if DEBUG
            //                      options = ["4 PM today", "9:30 AM tomorrow", "1 PM tomorrow", "checking", "savings", "savings"]
            //                      options = ["Yes", "No"]
            //                        options = ["4 PM today", "9:30 AM", "1 PM tomorrow"]
            //                        options = ["Checking", "Savings", "Brokerage"]
            //                        options = ["4 PM today", "9:30 AM tomorrow", "1 PM tomorrow", "checking"]
        #endif

        var mapUrlString: String?

        /// Check for maps
        if text.contains("InsMap1") {
            text = text.replacingOccurrences(of: "InsMap1", with: "")
            mapUrlString = Map.mapOne
        }

        if text.contains("InsMap2") {
            text = text.replacingOccurrences(of: "InsMap2", with: "")
            mapUrlString = Map.mapTwo
        }

        if text.contains("InsMap3") {
            text = text.replacingOccurrences(of: "InsMap3", with: "")
            mapUrlString = Map.mapThree
        }

        if text.contains("InsMap4") {
            text = text.replacingOccurrences(of: "InsMap4", with: "")
            mapUrlString = Map.mapFour
        }

        #if DEBUG
//            text = "I would suggest starting with the basics"
            text = "Let me show you a short video to see the effects of distracted driving"
        #endif
        self.delegate?.didReceiveMessage(withText: text, options: options)
        if let mapUrlString = mapUrlString, let mapUrl = URL(string: mapUrlString) {
            self.delegate?.didReceiveMap(withUrl: mapUrl)
        }

        if text.contains("Let me show you a short video") {
            let videoUrl = URL(fileURLWithPath: Video.videoOne)
            self.delegate?.didReceiveVideo(withUrl: videoUrl)
        }

        if text.contains("Let me show you what can happen") {
            let videoUrl = URL(fileURLWithPath: Video.videoTwo)
            self.delegate?.didReceiveVideo(withUrl: videoUrl)
        }

        // TBD: Remove me - for debug of map
        // strongSelf.delegate?.didReceiveMap(withUrl: URL(string: Map.mapOne)!)
    }

    func getValues() {
        var request = URLRequest(url: URL(string: GlobalConstants.valuesCall)!)
        request.httpMethod = Constants.httpMethodGet

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for fundamental networking error
            DispatchQueue.main.async { [weak self] in

                guard let data = data, error == nil else {
                    print("error=\(error)")
                    return
                }

                // check for http errors
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != Constants.statusCodeOK {
                    print("Failed with status code: \(httpStatus.statusCode)")
                }

                let xmlString = String(data: data, encoding: .utf8)

                self?.value1 = (self?.findMatch(pattern: "policyNumber>.*<", text: xmlString!))!
                self?.value1 = self?.value1?.replacingOccurrences(of: "policyNumber>", with: "")
                self?.value1 = self?.value1?.replacingOccurrences(of: "<", with: "")

                self?.value2 = (self?.findMatch(pattern: "causeOfLoss>.*<", text: xmlString!))!
                self?.value2 = self?.value2?.replacingOccurrences(of: "causeOfLoss>", with: "")
                self?.value2 = self?.value2?.replacingOccurrences(of: "<", with: "")

                var firstName = (self?.findMatch(pattern: "firstName>.*<", text: xmlString!))!
                firstName = firstName.replacingOccurrences(of: "firstName>", with: "")
                firstName = firstName.replacingOccurrences(of: "<", with: "")

                var lastName = (self?.findMatch(pattern: "lastName>.*</WX:lastName", text: xmlString!))!
                lastName = lastName.replacingOccurrences(of: "lastName>", with: "")
                lastName = lastName.replacingOccurrences(of: "</WX:lastName", with: "")

                self?.value3 = firstName + " " + lastName
                self?.sendMessage(withText: "Hi")
            }
        }

        /// Delay conversation request so as to give the keyboard time to dismiss and chat table view to scroll bottom
        let when = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when + 0.3) {
            task.resume()
        }
    }

    func findMatch(pattern: String, text: String) -> String {
        // Look for the option params in the brackets
        let nsString = text as NSString
        let regex = try! NSRegularExpression(pattern: pattern)
        if let result = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length)).first {
            let matchString = nsString.substring(with: result.range)
            return matchString
        }

        return ""
    }
}
