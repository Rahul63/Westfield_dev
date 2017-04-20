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
    func didReceiveImage(withUrl imageUrl: URL, andScale:String)
    func didReceiveImageResizeFactor(with Value:Float)
    func didReceiveVideo(withUrl videoUrl: URL)
    
    func didReceiveMessageForTexttoSpeech(withText text: String)
    
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
        static let idV = "id"
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
        print("Send Msg called")
        if firstName == nil && text == "-1" {
            firstName = text
            
            context = ""
        }
        //print("Send Msg called with text..\(text)")
        
       // let requestParameters = [workspace_id: '25dfa8a0-0263-471b-8980-317e68c30488',
                                // input: {'text': 'Turn on the lights'}]
        
        let userDataId = UserDefaults.standard.value(forKey: "UserDetail") as! NSArray
        let dict2 = userDataId[0] as? Dictionary<String,AnyObject>
        let idValue = (dict2?["_id"] as? String!)!
        
        let requestParameters =
            [Key.input: text,
//             Key.workspaceID: GlobalConstants.newConversationWorkspaceID, //changed
//             Key.firstName: firstName,
//             Key.lastName: Constants.lastName,
//             Key.nName: Constants.nName,
//             Key.cValue1: value1,
//             Key.cValue2: value2,
             Key.idV: idValue,
             Key.context: context
        ]

//        conversation.message({
//            workspace_id: '25dfa8a0-0263-471b-8980-317e68c30488',
//            input: {'text': 'Turn on the lights'},
//            context: context
//        }  
        
       // print("Send Msg called with Request.Para.\(requestParameters)")
        var request = URLRequest(url: URL(string: GlobalConstants.wcsWorkflowURL)!)
        
        //var request = URLRequest(url: URL(string: GlobalConstants.wcsWorkflowURL)!)
        request.httpMethod = Constants.httpMethodPost
//        let useCred = String(format: "%@:%@",GlobalConstants.wcsUserName,GlobalConstants.wcsPassword)
//        let credData = useCred.data(using: String.Encoding.utf8)
//        let final64V = credData?.base64EncodedString()
        //request.setValue("Basic Auth\(final64V)", forHTTPHeaderField: "Authorization")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestParameters.stringFromHttpParameters().data(using: .utf8)
        
        //print("Send Msg called with BODYYYYYYYYY>>>>>>>>>>.\(requestParameters.stringFromHttpParameters())")
        
       // print("Send Msg called with request Body..\(request)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for fundamental networking error
            DispatchQueue.main.async { [weak self] in

                guard let data = data, error == nil else {
                    //print("error=\(error)")
                    return
                }

                // check for http errors
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != Constants.statusCodeOK {
                   // print("Failed with status code: \(httpStatus.statusCode)")
                }

                let responseString = String(data: data, encoding: .utf8)
                if let data = responseString?.data(using: String.Encoding.utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                           // print("JSON Value...\(json)")
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
        var text = json["text"] as! String//"<vid:src>https://ibm.box.com/shared/static/xlpe595snnem4swkvtihq0cz024un5s5.mp4</vid:src><br>Hi, I am glad you stopped by.  C’mon in.  I’m Max Safety, you can call me Max. I see you are from CIX DIRECT, LLC.  Good to meet you, what’s your name?" //json["text"] as! String//"Take a quick look at this Picture.  What do you see?<br><img:src>https://ibm.box.com/shared/static/umxb5mo37ypc28zz3iptaqqflgt1fk3d.jpg</img:src>"//json["text"] as! String
        
        // "<img:src resize=0.75>https://ibm.box.com/shared/static/umxb5mo37ypc28zz3iptaqqflgt1fk3d.jpg</img:src> That’s great, glad to hear it.<br>,Hey Rahul , please take a quick look at my <a href=\"https://ibm.box.com/shared/static/3dp3x8gc7ar1t5orlaa0zcayjzejwfox.png\"><sub alias=\"resumay\">résumé</sub></a>"//
        
       // var text  = "<img:src>https://ibm.box.com/shared/static/3cxzelnbpjm1og53abxnt3x5cjs1fbus.jpg</img:src><br>I’m sure your employees only want to work hard for you. They might not realize that what seems like a routine pill for pain could negatively impact their driving ability.\",\"Give me your best guess on how many adults you think have used prescription drugs in the past 30 days.<br><br><wcs:input>80%</wcs:input><br><br><wcs:input>50%</wcs:input><br><br><wcs:input>30%</wcs:input>"
        
         //var text  = "<vid:src>https://ibm.box.com/shared/static/xlpe595snnem4swkvtihq0cz024un5s5.mp4</vid:src><br>That’s great $User_First_Name, you are ahead of the competition. Most app stores have apps that can send an automatic text saying they are driving or even block incoming call alerts or test messages. Here is a <a href=\"https://www.verizonwireless.com/archive/mobile-living/home-and-family/apps-to-block-texting-while-driving\">list of apps</a> you can use on your company phones.<br><br>Ready to continue?"
        
        
        //print("JSSSOONN>>>>\(text)")
        var opt = [String]()
        
        self.delegate?.didReceiveMessageForTexttoSpeech(withText: text)
        
        
        
        //<badgeCount>(\\d+)</badgeCount>
        
        var scaleValue = ""
        
        let range2 = text.range(of: "(?<=<img:src resize=)[^><]+(?=>)", options: .regularExpression)
        if range2 != nil {
            var optionsString = text.substring(with: range2!)
            optionsString = optionsString.replacingOccurrences(of: "\"", with: "")
            //print(optionsString)
            scaleValue = optionsString
            //self.delegate?.didReceiveImageResizeFactor(with: Float(optionsString)! )
            let rangeReplace = text.range(of: "<img:src[^>]*>", options: .regularExpression)
            if rangeReplace != nil {
                var optionsStringIm = text.substring(with: rangeReplace!)
                optionsStringIm = optionsStringIm.replacingOccurrences(of: "\"", with: "")
                //print(optionsStringIm)
                //print(text)
                text = text.replacingOccurrences(of: optionsStringIm, with: "<img:src>")
                //print(text)
            }
            
        }
        var textN = text.replacingOccurrences(of: "", with: " ")
        //var foundText = textN.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        //let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\"\\]\\)])")
        let rangeImage = text.range(of:"<img:src>(.*?)</img:src>", options:.regularExpression)
        let rangeVideo = text.range(of:"<vid:src>(.*?)</vid:src>", options:.regularExpression)
        
        if (rangeImage != nil) {
        
            var optionsString = text.substring(with: rangeImage!)
            textN = textN.replacingOccurrences(of: optionsString, with: "MIVD.n&n")
            textN = textN.replacingOccurrences(of: "\",\"", with: "n&n")
            //textN = textN.replacingOccurrences(of: "<br>", with: "")
            optionsString = optionsString.replacingOccurrences(of: "<img:src>", with: "")
            optionsString = optionsString.replacingOccurrences(of: "</img:src>", with: "")
            optionsString = optionsString.replacingOccurrences(of: "</vid:src", with: "")
            optionsString = optionsString.replacingOccurrences(of: "<vid:src>", with: "")
            //print("With optionsString..\(optionsString)>>>>>>>>>>>>>>")
            
            opt = textN.components(separatedBy: "n&n")
            //print(opt)
            if opt.count > 0{
                for item in 0..<opt.count{
                    /// sleep(1)
                    var chatTxt = opt[item]
                    //print(chatTxt)
                    chatTxt = chatTxt.replacingOccurrences(of: "</vid:src>", with: "")
                    chatTxt = chatTxt.replacingOccurrences(of: "</img:src>", with: "")
                    if chatTxt.contains("MIVD.") {
                        chatTxt = chatTxt.replacingOccurrences(of: "MIVD.", with: "")
                        chatTxt = chatTxt.replacingOccurrences(of: "<img:src>", with: "")
                        if chatTxt.characters.count>0 {
                            self.delegate?.didReceiveMessage(withText: chatTxt, options: nil)
                        }
                        
                        let imageUrl = URL(string: optionsString)
                        if scaleValue != "" {
                            self.delegate?.didReceiveImage(withUrl: imageUrl!, andScale: scaleValue)
                        }else{
                            self.delegate?.didReceiveImage(withUrl: imageUrl!, andScale: "1.0")
                        }
                        
                    }else{
                        self.delegate?.didReceiveMessage(withText: chatTxt, options: nil)
                    }
                    
                }
            }
            else{
                self.delegate?.didReceiveMessage(withText: text, options: nil)
            }
        }
        else if (rangeVideo != nil){
            
            var optionsString = text.substring(with: rangeVideo!)
            textN = textN.replacingOccurrences(of: optionsString, with: "MIVD.n&n")
            //textN = textN.replacingOccurrences(of: "<br>", with: "")
            textN = textN.replacingOccurrences(of: "\",\"", with: "n&n")
            
            optionsString = optionsString.replacingOccurrences(of: "<img:src>", with: "")
            optionsString = optionsString.replacingOccurrences(of: "</img:src>", with: "")
            optionsString = optionsString.replacingOccurrences(of: "</vid:src>", with: "")
            optionsString = optionsString.replacingOccurrences(of: "<vid:src>", with: "")
            //optionsString.append(<#T##c: Character##Character#>)
            //print("With optionsString.Video.\(optionsString)>>>>>>>>>>>>>>")
            opt = textN.components(separatedBy: "n&n")
            
            //print(opt)
            if opt.count > 0{
                for item in 0..<opt.count{
                    /// sleep(1)
                    var chatTxt = opt[item]
                    //print(chatTxt)
                    chatTxt = chatTxt.replacingOccurrences(of: "</vid:src>", with: "")
                    chatTxt = chatTxt.replacingOccurrences(of: "</img:src>", with: "")
                    if chatTxt.contains("MIVD.") {
                        chatTxt = chatTxt.replacingOccurrences(of: "MIVD.", with: "")
                        
                       // chatTxt = chatTxt.replacingOccurrences(of: "<br>", with: "")
                        
                        chatTxt = chatTxt.replacingOccurrences(of: "<vid:src>", with: "")
                        if chatTxt.characters.count>0 {
                            self.delegate?.didReceiveMessage(withText: chatTxt, options: nil)
                        }
                        let videoUrl = URL(string: optionsString)
                        self.delegate?.didReceiveVideo(withUrl: videoUrl!)
                        
                    }else{
                        self.delegate?.didReceiveMessage(withText: chatTxt, options: nil)
                    }
                    
                }
            
        }
        }
        else{
           self.delegate?.didReceiveMessage(withText: text, options: nil)
        }
        
        /*
        let regex = try! NSRegularExpression(pattern: "<img:src>(.*?)</img:src>")
        let nsString = textN as NSString
        print(nsString)
        if let result = regex.matches(in: textN, range: NSRange(location: 0, length: nsString.length)).last {
            
            var optionsString = nsString.substring(with: result.range)
            optionsString = optionsString.replacingOccurrences(of: "<img:src>", with: "")
            optionsString = optionsString.replacingOccurrences(of: "</img:src", with: "")
            optionsString = optionsString.replacingOccurrences(of: "</vid:src", with: "")
            optionsString = optionsString.replacingOccurrences(of: "<vid:src>", with: "")
            print("With optionsString..\(optionsString)>>>>>>>>>>>>>>")
            textN = textN.replacingOccurrences(of: "<img:src>", with: "")
            textN = textN.replacingOccurrences(of: "</img:src>", with: "")
            
            textN = textN.replacingOccurrences(of: optionsString, with: "MIVD.n&n")
            textN = textN.replacingOccurrences(of: "\",\"", with: "n&n")
            opt = textN.components(separatedBy: "n&n")
            print(opt)
            if opt.count > 0{
                for item in 0..<opt.count{
                   /// sleep(1)
                    var chatTxt = opt[item]
                    print(chatTxt)
                    chatTxt = chatTxt.replacingOccurrences(of: "</vid:src>", with: "")
                    chatTxt = chatTxt.replacingOccurrences(of: "</img:src>", with: "")
                    if chatTxt.contains("MIVD.") {
                        chatTxt = chatTxt.replacingOccurrences(of: "MIVD.", with: "")
                        if chatTxt.contains("<vid:src>"){
                            chatTxt = chatTxt.replacingOccurrences(of: "<vid:src>", with: "")
                            if chatTxt.characters.count>0 {
                                self.delegate?.didReceiveMessage(withText: chatTxt, options: nil)
                            }
                            let videoUrl = URL(string: optionsString)
                            self.delegate?.didReceiveVideo(withUrl: videoUrl!)
                        }
                        if chatTxt.contains("<img:src>"){
                            chatTxt = chatTxt.replacingOccurrences(of: "<img:src>", with: "")
                            if chatTxt.characters.count>0 {
                                self.delegate?.didReceiveMessage(withText: chatTxt, options: nil)
                            }
                            
                            let imageUrl = URL(string: optionsString)
                            self.delegate?.didReceiveImage(withUrl: imageUrl!)
                        }
                    }else{
                        self.delegate?.didReceiveMessage(withText: chatTxt, options: nil)
                    }
                    
                }
            }
            else{
                self.delegate?.didReceiveMessage(withText: text, options: nil)
            }
        }
        let regex2 = try! NSRegularExpression(pattern: "<vid:src>(.*?)</vid:src>")
        print(nsString)
        if let result = regex2.matches(in: textN, range: NSRange(location: 0, length: nsString.length)).last {
            var optionsString = nsString.substring(with: result.range)
            optionsString = optionsString.replacingOccurrences(of: "<img:src>", with: "")
            optionsString = optionsString.replacingOccurrences(of: "</img:src", with: "")
            optionsString = optionsString.replacingOccurrences(of: "</vid:src", with: "")
            optionsString = optionsString.replacingOccurrences(of: "<vid:src>", with: "")
            print("With optionsString..\(optionsString)>>>>>>>>>>>>>>")
            textN = textN.replacingOccurrences(of: optionsString, with: "MIVD.n&n")
            textN = textN.replacingOccurrences(of: "\",\"", with: "n&n")
            opt = textN.components(separatedBy: "n&n")
            print(opt)
            if opt.count > 0{
                for item in 0..<opt.count{
                    /// sleep(1)
                    var chatTxt = opt[item]
                    print(chatTxt)
                    chatTxt = chatTxt.replacingOccurrences(of: "</vid:src>", with: "")
                    chatTxt = chatTxt.replacingOccurrences(of: "</img:src>", with: "")
                    if chatTxt.contains("MIVD.") {
                        chatTxt = chatTxt.replacingOccurrences(of: "MIVD.", with: "")
                        if chatTxt.contains("<vid:src>"){
                            chatTxt = chatTxt.replacingOccurrences(of: "<vid:src>", with: "")
                            if chatTxt.characters.count>0 {
                                self.delegate?.didReceiveMessage(withText: chatTxt, options: nil)
                            }
                            let videoUrl = URL(string: optionsString)
                            self.delegate?.didReceiveVideo(withUrl: videoUrl!)
                        }
                        if chatTxt.contains("<img:src>"){
                            chatTxt = chatTxt.replacingOccurrences(of: "<img:src>", with: "")
                            if chatTxt.characters.count>0 {
                                self.delegate?.didReceiveMessage(withText: chatTxt, options: nil)
                            }
                            
                            let imageUrl = URL(string: optionsString)
                            self.delegate?.didReceiveImage(withUrl: imageUrl!)
                        }
                    }else{
                        self.delegate?.didReceiveMessage(withText: chatTxt, options: nil)
                    }
                    
                }
            }
            else{
                self.delegate?.didReceiveMessage(withText: text, options: nil)
            }
        }
            
        else{
           self.delegate?.didReceiveMessage(withText: text, options: nil)
        }
        
//        let nsString = "<vid:src>https://ibm.box.com/shared/static/xlpe595snnem4swkvtihq0cz024un5s5.mp4</vid:src><br>Hi, I am glad you stopped by.  C’mon in.  I’m Max Safety, you can call me Max. I see you are from CIX DIRECT, LLC.  Good to meet you, what’s your name?" as NSString//text as NSString
//        //let regex = try! NSRegularExpression(pattern: "<.*?>")
//        let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])")
//        
//        if let result = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length)).last {
//            var optionsString = nsString.substring(with: result.range)
//            optionsString = optionsString.replacingOccurrences(of: "\\", with: "")
//            optionsString = optionsString.replacingOccurrences(of: "</vid:src", with: "")
//            optionsString = optionsString.replacingOccurrences(of: "</img:src", with: "")
//            print(optionsString)
//        
//        if text.contains("<vid:src>") {
//            let videoUrl = URL(string: optionsString)
//            self.delegate?.didReceiveVideo(withUrl: videoUrl!)
//        }
//        if text.contains("<img:src>") {
//            let imageUrl = URL(string: optionsString)
//            self.delegate?.didReceiveImage(withUrl: imageUrl!)
//            
//        }
//            
//        }
        
        
        
        
        
        
        
       /* if text.contains("<img:src>") {
            
            //                optionsString = optionsString.replacingOccurrences(of: "</img:src", with: "")
            //
            //                print("myImage URL is...<<<<<<<.\(optionsString)")
            //                print("Images to be shown")
            //                var clearStr = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            //                clearStr = clearStr.replacingOccurrences(of: ">", with: "")
            //                let yValue: CGFloat  = self.heightForView(text: clearStr, font: UIFont.systemFont(ofSize: 10), width: messageLabel.frame.size.width)-10
            //                //text = text.replacingOccurrences(of: ">", with: "")
            //                text.append("\n\n\n\n\n\n\n\n\n\n")
            //
            //                text = text.replacingOccurrences(of: optionsString, with: "")
            //                let range = text.range(of:"(?=<)[^.]+(?=>)", options:.regularExpression)
            //                if range != nil {
            //
            //                    text = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            //                    text = text.replacingOccurrences(of: ">", with: "")
            //
            //                    messageLabel.text = text
            //                }
            //
            //                let url = URL(string:optionsString)//"https://ibm.box.com/shared/static/umxb5mo37ypc28zz3iptaqqflgt1fk3d.jpg")//"http://cdn.businessoffashion.com/site/uploads/2014/09/Karl-Lagerfeld-Self-Portrait-Courtesy.jpg")
            //               // let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            //
            //                let imageView = UIImageView(frame: CGRect(x: 0, y: yValue, width: 210, height: 230))
            //               // imageView.loadRequest(NSURLRequest(url: NSURL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")! as URL) as URLRequest)
            //                //imageView.sd_setImage(with: url)
            //                //imageView.setShowActivityIndicator(true)
            //
            //                imageView.sd_setImage(with: url)
            //                //imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            //
            //                //imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), completed: {})
            //                imageView.contentMode = .scaleAspectFit
            //                self.messageLabel.addSubview(imageView)
            //                //imageView.image = UIImage(data: data!)
            //                //self.addImageToImageView(with: "", and: 30)
            
        }
        else if text.contains("<vid:src>"){
            //                optionsString = optionsString.replacingOccurrences(of: "</vid:src", with: "")
            //                var clearStr = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            //                clearStr = clearStr.replacingOccurrences(of: ">", with: "")
            //
            //                let yValue: CGFloat  = self.heightForView(text: clearStr, font: UIFont.systemFont(ofSize: 10), width: messageLabel.frame.size.width)-30
            //                print("myVideo URL is...<<<<<<<.\(optionsString)")
            //                text.append("\n\n\n\n\n\n\n\n\n")
            //
            //                text = text.replacingOccurrences(of: optionsString, with: "")
            //                let range = text.range(of:"(?=<)[^.]+(?=>)", options:.regularExpression)
            //                if range != nil {
            //
            //                    text = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            //                    text = text.replacingOccurrences(of: ">", with: "")
            //
            //                    messageLabel.text = text
            //                }
            //
            //                //if (optionsString.contains("mp4")) {
            //                    let videoURL = URL(string: optionsString)//"https://app.box.com/shared/static/nj2zla5uxzf4r0em1tl8q0bqk7b5huuq.mp4")//"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
            //                    
            //                    let player = AVPlayer(url: videoURL!)
            //                    let playerLayer = AVPlayerLayer(player: player)
            //                    playerLayer.frame = CGRect(x: 0, y: yValue, width: 210, height: 260)
            //                    self.messageLabel.layer.addSublayer(playerLayer)
            //                    player.play()
            //                //}
            
            
            
        }*/
        
        
        
        
        
        
        
        
        
        

        // Look for the option params in the brackets
  //      let nsString = text as NSString
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
        }*/

        // TBD: Remove me - for debug of map
        // strongSelf.delegate?.didReceiveMap(withUrl: URL(string: Map.mapOne)!)
    }

    func getValues() {
        
        self.sendMessage(withText: "-1")
//        var request = URLRequest(url: URL(string: GlobalConstants.valuesCall)!)
//        request.httpMethod = Constants.httpMethodGet
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            // check for fundamental networking error
//            DispatchQueue.main.async { [weak self] in
//
//                guard let data = data, error == nil else {
//                    print("error=\(error)")
//                    return
//                }
//
//                // check for http errors
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != Constants.statusCodeOK {
//                    //print("Failed with status code: \(httpStatus.description)")
//                }
//
//                let xmlString = String(data: data, encoding: .utf8)
//
//                self?.value1 = (self?.findMatch(pattern: "policyNumber>.*<", text: xmlString!))!
//                self?.value1 = self?.value1?.replacingOccurrences(of: "policyNumber>", with: "")
//                self?.value1 = self?.value1?.replacingOccurrences(of: "<", with: "")
//
//                self?.value2 = (self?.findMatch(pattern: "causeOfLoss>.*<", text: xmlString!))!
//                self?.value2 = self?.value2?.replacingOccurrences(of: "causeOfLoss>", with: "")
//                self?.value2 = self?.value2?.replacingOccurrences(of: "<", with: "")
//
//                var firstName = (self?.findMatch(pattern: "firstName>.*<", text: xmlString!))!
//                firstName = firstName.replacingOccurrences(of: "firstName>", with: "")
//                firstName = firstName.replacingOccurrences(of: "<", with: "")
//
//                var lastName = (self?.findMatch(pattern: "lastName>.*</WX:lastName", text: xmlString!))!
//                lastName = lastName.replacingOccurrences(of: "lastName>", with: "")
//                lastName = lastName.replacingOccurrences(of: "</WX:lastName", with: "")
//
//                self?.value3 = firstName + " " + lastName
//                
//            }
//        }
//
//        /// Delay conversation request so as to give the keyboard time to dismiss and chat table view to scroll bottom
//        let when = DispatchTime.now()
//        DispatchQueue.main.asyncAfter(deadline: when + 0.3) {
//            task.resume()
//        }
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













//var request = URLRequest(url: url!)
//request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
//request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
//request.httpMethod = "POST"
//
//let dictionary = ["email": usr, "userPwd": pwdCode]
//request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary)
//
//let task = URLSession.shared.dataTask(with: request) { data, response, error in
//    guard let data = data, error == nil else {
