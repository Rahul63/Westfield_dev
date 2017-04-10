//
//  WatsonChatViewCell.swift
//  WatsonDemo
//
//  Created by Etay Luz on 11/13/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

import TTTAttributedLabel
import UIKit
import AVFoundation


protocol watsonChatCellDelegate
{
    func loadUrlLink(url : String?)
    func SendMessageWithButtonValue(with value:String)
    
    // loadUrlLink(result: Int)
}

class WatsonChatViewCell: UITableViewCell {
   // let buttonOptions = KGRadioButton()
    var delegate: watsonChatCellDelegate!
    

    // MARK: - Doc
    private struct Doc {
        
        static var linkUrl = ""
        static let employerPolicy = "https://drive.google.com/file/d/0B-UVZVvBHs8uUjJiSXJlS2NXRGxOd3YtX1cxbExhYXhfUXlz/view?usp=sharing"
        static let driverTraining = "https://drive.google.com/file/d/0B-UVZVvBHs8uQ1puaXhBYS11SFdfUHZEWXZqSFN2T29xSmMw/view?usp=sharing"
        static let vehicleInspection = "https://drive.google.com/file/d/0B-UVZVvBHs8ueVVDOHkza2hKNVNyanNZSXFUTkFpZldnSEdR/view?usp=sharing"
        static let fleetProgram = "https://drive.google.com/file/d/0B-UVZVvBHs8uRjUySlZLYS1mYTdqU3FzbkNvVzlJaTBfajBV/view?usp=sharing"
    }

    // MARK: - Outlets

    @IBOutlet weak var chatBGvw: CustomView!
    @IBOutlet weak var messageLabel: TTTAttributedLabel!
    @IBOutlet weak var watsonIcon: UIImageView!
    var optionData = [String]()
    var chatViewController: ChatViewController?
    /// Configure Watson chat table view cell with Watson message
    ///
    /// - Parameter message: Message instance
    func configure(withMessage message: Message) {
        
        //var text = "Take a quick look at this picture.  What do you see?<br><vid:src>https://app.box.com/s/jhspb9tq2vw1ntdwjemkfydk17nzg6hx</vid:src>"
        
        //var text = "My review finds that (named insured) has ownership of considerable assets and my job is to recommend approaches for you to protect those assets. Which of these is crucial to your business? <br><br><wcs:input>Equipment</wcs:input><br><br><wcs:input>Employees</wcs:input><br><br><wcs:input>Customers</wcs:input><br><br><wcs:input>Reputation</wcs:input><br><br><wcs:input>All of the Above</wcs:input>,"
        
        var text = message.text!//"rahul , I happen to have one (insert Box link here) in my toolkit.  You will see it’s short and simple, but powerful.  Take a look at it, if you agree, place it on your letterhead, add your name and sign it. Management commitment is step one; your employees need to take ownership as well.  As part of your training program, watch and share <a href=\\\"https://www.youtube.com/watch?v=Km8XxRCuCho\\\">this video</a> with your team. After they have watched it, conduct a brief meeting with them to share your safety policy and discuss the video with them. May I continue?"//message.text!
        
        //print("My final text..>\(text)")
        messageLabel.delegate = self
        text = text.replacingOccurrences(of: "<br>", with: "\n")
        optionData = [""]
        text = text.replacingOccurrences(of: "\",\"", with: "\n\n")
        //text = text.replacingOccurrences(of: "\\", with: "")
        
        for view in self.messageLabel.subviews
        {
            //if view .isKind(of: KGRadioButton.self) {
               // print(">>>>>>>>>>>>>Removeddddddd")
                view.removeFromSuperview()
            //}
            
            
        }
        print(self.chatBGvw.frame.width)
        let nsString = text as NSString
        //let regex = try! NSRegularExpression(pattern: "<.*?>")
        let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])")
        
        if let result = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length)).last {
            var optionsString = nsString.substring(with: result.range)
            optionsString = optionsString.replacingOccurrences(of: "\\", with: "")
            
            
     /*       if text.contains("<img:src>") {
                
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
                
                
                
            }
            else{
            */
                Doc.linkUrl = optionsString
                print("myOptionalString is...<<<<<<<.\(optionsString)")
                text = text.replacingOccurrences(of: optionsString, with: "")
                let range = text.range(of:"(?=<)[^.]+(?=>)", options:.regularExpression)
                if range != nil {
                    var found = text.substring(with: range!)
                    print("found: \(found)") // found: google
                    
                    found = found.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    found = found.replacingOccurrences(of: "</a", with: "")
                    //print("found:>>>> \(found)")
                    text = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    text = text.replacingOccurrences(of: ">", with: "")
                    let nsText = text as NSString
                    let range1: NSRange = nsText.range(of: found)
                    messageLabel.text = text
                    // print("MyURLLL>>>>\(Doc.linkUrl)")
                    messageLabel.addLink(to: URL(string: Doc.linkUrl) , with: range1)
                    
               // }
                
            }
            

            //print("mytext is...<<<<<<<.\(text)")
            
        }
            
        else{
            
            var foundNew = ""
            var inputText = ""
            inputText = text.replacingOccurrences(of: "<[^>]+>", with: "        ", options: .regularExpression, range: nil)
            inputText = inputText.replacingOccurrences(of: "  ,", with: "")
            
            //print("mytext is..ELSEEEEEE.<<<<<<<.\(text)")
            messageLabel.text = inputText
            
            let rangeNew = text.range(of:"(?=<)[^.]+(?=>)", options:.regularExpression)
            let rangeNew2 = text.range(of:"(?=<)[^.]+(?=<\\)", options:.regularExpression)
            if (rangeNew != nil || rangeNew2 != nil) {
                 foundNew = text.substring(with: rangeNew!)
                
                var strinLength = text.replacingOccurrences(of: foundNew, with: "")
                //print(strinLength)
                //strinLength = strinLength.replacingOccurrences(of: " ", with: "")
                strinLength = strinLength.replacingOccurrences(of: ">,", with: "")
                strinLength = strinLength.replacingOccurrences(of: ">", with: "")
                //let strinLengthCount:Int = strinLength.characters.count
                //print("mystringLength>>>>\(strinLengthCount)")
                print(strinLength)
                var foundNewData = foundNew.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                foundNewData = foundNewData.replacingOccurrences(of: "</wcs:input", with: "")
                foundNewData = foundNewData.replacingOccurrences(of: "\n\n", with: "n&n")
                optionData = foundNewData.components(separatedBy: "n&n")
                print(optionData)
                
                var yValue: CGFloat = 0.0
                let heightStr = strinLength.replacingOccurrences(of: "", with: "")
                
//                let labelSize = rectForText(text: heightStr, font: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width:messageLabel.frame.width, height:999))
//                print(self.chatBGvw.frame.width)
//                let labelHeight = labelSize.height
//                print("my label height\(labelHeight)")
//                yValue = labelHeight
                
                 yValue  = self.heightForView(text: heightStr, font: UIFont.systemFont(ofSize: 14), width: messageLabel.frame.size.width)
                //print("print yvalue...\(yValue)")
                if optionData.count>0 {
                    for (index,element) in optionData.enumerated() {
                        let buttonOptions = KGRadioButton()
                        buttonOptions.frame = CGRect(x: 0, y: yValue, width: 20, height: 20)
                        let label2 = UILabel(frame: CGRect(x: 35, y: yValue, width: 200, height: 25))
                        label2.font = UIFont.systemFont(ofSize: 14)
                        
                        
                        buttonOptions.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
                        buttonOptions.outerCircleColor = UIColor(red: 0.0/255, green: 122.0/255, blue: 255.0/255, alpha: 1)
                        buttonOptions.tag = index
                        buttonOptions.clipsToBounds = true
                        
                        
                        
                        self.messageLabel.addSubview(buttonOptions)
                        label2.text = element
                        // self.messageLabel.addSubview(label2)
                        //print(index,element)
                        yValue += 33
                        
                    }
                }
                
                
                //print("found ALL>>>>>: \(foundNew)")
                
                //print("found ALL>>>OPTION>>: \(optionData) and count\(optionData.count)")
            }
            
            
        }
        
        }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        var currHeight:CGFloat = 0.0
        
        let  newTex = text
        
        
//        newTex = newTex.replacingOccurrences(of: "\n", with: "")
//        newTex = newTex.replacingOccurrences(of: " ", with: "")
        print("my convertable text..\(newTex)")
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: messageLabel.frame.size.width, height: messageLabel.frame.size.height))//CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.textAlignment = .natural
        //label.lineBreakMode = NSLineBreakMode.by
        label.font = font
        label.text = newTex
        
        label.sizeToFit()
        label.clipsToBounds = true
        currHeight = label.frame.size.height
        label.removeFromSuperview()
        print(" current height..\(currHeight)")
        return currHeight-18
    }
    
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width:rect.size.width, height:rect.size.height)
        print(size)
        return size
    }
        
        
        
        
        
        
        
    func manualAction (sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        
        
        
        if sender.isSelected {
            
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "ChatfieldShouldRefresh"), object: self, userInfo: "test" as Any)
            //self.chatViewController?.conversationService.sendMessage(withText: optionData[sender.tag])
//                        let userMessage = Message(type: MessageType.User, text: optionData[sender.tag], options: nil)
//                        self.chatViewController?.appendChat(withMessage: userMessage)
            self.delegate?.SendMessageWithButtonValue(with: optionData[sender.tag])
            
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "ChatfieldShouldRefresh"), object: optionData[sender.tag])
        } else{
        }
    }

        //setupHyperLinks()
    //}

    private func setupHyperLinks() {
        guard var text = messageLabel.text  else { return }

        messageLabel.delegate = self

        if (text.contains("Please review and apply the ideas on this outline to set up a Preventative Maintenance program.")) {
            text.append(" 1. Fleet  program, 2. Vehicle Inspection.")
            messageLabel.text = text
            let nsText = text as NSString
            let range1: NSRange = nsText.range(of: "Fleet  program")
            messageLabel.addLink(to: URL(string: Doc.fleetProgram) , with: range1)

            let range2: NSRange = nsText.range(of: "Vehicle Inspection")
            messageLabel.addLink(to: URL(string: Doc.vehicleInspection) , with: range2)
        }

        if (text.contains("I would suggest starting with the basics")) {
            text.append(" 1. Sample employer policy, 2. Driver training DD")
            messageLabel.text = text
            let nsText = text as NSString
            let range1: NSRange = nsText.range(of: "Sample employer policy")
            messageLabel.addLink(to: URL(string: Doc.employerPolicy) , with: range1)

            let range2: NSRange = nsText.range(of: "Driver training DD")
            messageLabel.addLink(to: URL(string: Doc.driverTraining) , with: range2)
        }

    }

    
    func loadDetlVw()  {
        //
    }
    
    
    
    
    func addImageToImageView(with url: String, and yValue: Int) {
        let catPictureURL = URL(string: "https://app.box.com/s/jhspb9tq2vw1ntdwjemkfydk17nzg6hx")!
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        
                        let imageView = UIImageView(frame: CGRect(x: 35, y: yValue, width: Int(self.messageLabel.frame.size.width), height: 180))
                        imageView.image = image
                        self.messageLabel.addSubview(imageView)
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    
    


func alert(_ title: String, message: String) {
//    let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//    vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    //self.present(vc, animated: true, completion: nil)
    //        iconView = UIImageView(frame: CGRect(x: (self.frame.width-image.size.width)/2, y: (self.frame.height-image.size
    //            .height)/2, width: self.frame.width, height: self.frame.height))

    //self.delegate.loadUrlLink(url: message)
}
}


 //MARK: - ConversationServiceDelegate
extension WatsonChatViewCell: TTTAttributedLabelDelegate {

    public func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
       // UIApplication.shared.openURL(url)
        let urlString: String = url.absoluteString
        self.delegate.loadUrlLink(url:urlString)
    }
    
}
