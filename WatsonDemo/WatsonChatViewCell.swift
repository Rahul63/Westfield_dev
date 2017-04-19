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

class WatsonChatViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
   // let buttonOptions = KGRadioButton()
    var delegate: watsonChatCellDelegate!
    @IBOutlet weak var chatBubbleTableView: UITableView!
    @IBOutlet weak var chatStackView: UIStackView!
    

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
    @IBOutlet weak var heightLable: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var optionData = [String]()
    var chatViewController: ChatViewController?
    /// Configure Watson chat table view cell with Watson message
    ///
    /// - Parameter message: Message instance
    func configure(withMessage message: Message) {
        self.addItemsInStckView()
        //self.chatBubbleTableView.reloadData()
        
        //self.heightConstraint.constant = 300
        
       // print("myLabel Posion....\(heightLable.frame.maxY,heightLable.frame)")
        
        //var text = "Take a quick look at this picture.  What do you see?<br><vid:src>https://app.box.com/s/jhspb9tq2vw1ntdwjemkfydk17nzg6hx</vid:src>"
        
        //var text = "My review finds that (named insured) has ownership of considerable assets and my job is to recommend approaches for you to protect those assets. Which of these is crucial to your business? <br><br><wcs:input>Equipment</wcs:input><br><br><wcs:input>Employees</wcs:input><br><br><wcs:input>Customers</wcs:input><br><br><wcs:input>Reputation<//wcs:input><br><br><wcs:input>All of the Above</wcs:input>,"
        
        var text = message.text!//"rahul , I happen to have one (insert Box link here) in my toolkit.  You will see it’s short and simple, but powerful.  Take a look at it, if you agree, place it on your letterhead, add your name and sign it. Management commitment is step one; your employees need to take ownership as well.  As part of your training program, watch and share <a href=\\\"https://www.youtube.com/watch?v=Km8XxRCuCho\\\">this video</a> with your team. After they have watched it, conduct a brief meeting with them to share your safety policy and discuss the video with them. May I continue?"//message.text!
        
        //print("My final text.To chat buuble.>\(text)")
        messageLabel.delegate = self
        
        for aView in chatStackView.arrangedSubviews{
            //print("Myyy view before remved\(aView)")
            if aView .isKind(of: UIStackView.self) {
                //print("Myyy view remved Stackk\(aView)")
                chatStackView.removeArrangedSubview(aView)
                aView.removeFromSuperview()
            }
        }
        
        if text.contains("</sub>"){
            let rangeImage = text.range(of:"<sub[^>]*>(.*\n?)</sub>", options:.regularExpression)
            if rangeImage != nil {
                let optionsStringNew = text.substring(with: rangeImage!)
                let textStr = optionsStringNew.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                //print("optionsStringNew>>>>>>>>>>*********>>>>>>>\(optionsStringNew)")
                //print(">>>>>>>>>textStr<<<<<<<<<BTWN.............&&&&&&...\(textStr)")
                text = text.replacingOccurrences(of: optionsStringNew, with: textStr)
                print(text)
            }
        }
        
        text = text.replacingOccurrences(of: "<br>", with: "\n")
        optionData.removeAll()
        text = text.replacingOccurrences(of: "\",\"", with: "\n\n")

        let nsString = text as NSString
        let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])")
        
        if let result = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length)).last {
            var optionsString = nsString.substring(with: result.range)
            optionsString = optionsString.replacingOccurrences(of: "\\", with: "")
            Doc.linkUrl = optionsString
            //print("myOptionalString is...<<<<<<<.\(optionsString)")
            text = text.replacingOccurrences(of: optionsString, with: "")
            let range = text.range(of:"(?=<)[^.]+(?=>)", options:.regularExpression)
            if range != nil {
                var found = text.substring(with: range!)
                //print("found: \(found)") // found: google
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
            
            var foundNew = text
           // print("nextStep...\(text)")
            
            let rangeNew = foundNew.range(of:"(?=<)[^.]+(?=>)", options:.regularExpression)
            let rangeNew2 = foundNew.range(of:"(?=<)[^.]+(?=<\\)", options:.regularExpression)
            if (rangeNew != nil || rangeNew2 != nil) {
                let subString = foundNew.substring(with: rangeNew!)
               // print("lets internal Value..\(foundNew)")
                //print("lets internal subString..\(subString)")
                var strinLength = foundNew.replacingOccurrences(of: subString, with: "")
                //print("Strint to bubble...\(strinLength)")
                strinLength = strinLength.replacingOccurrences(of: ">,", with: "")
                strinLength = strinLength.replacingOccurrences(of: ">", with: "")
                strinLength = strinLength.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                messageLabel.text = strinLength
                //print(strinLength)
                if subString.contains("<wcs:input>") {
                    var foundRedioBtnData = subString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    foundRedioBtnData = foundRedioBtnData.replacingOccurrences(of: "</wcs:input", with: "")
                    foundRedioBtnData = foundRedioBtnData.replacingOccurrences(of: "\n\n", with: "n&n")
                    optionData = foundRedioBtnData.components(separatedBy: "n&n")
                    print(optionData)
                }
                
                
                if optionData.count>0 {
                    self.addRadioButtonsWithTitle(count: optionData.count)
                }
                //print("found ALL>>>>>: \(foundNew)")
                //print("found ALL>>>OPTION>>: \(optionData) and count\(optionData.count)")
            }else{
                foundNew = foundNew.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                messageLabel.text = foundNew
            }
        }
        
        
    }
    
    
    func addItemsInStckView() {
        
        chatStackView.axis  = UILayoutConstraintAxis.vertical
        chatStackView.alignment = UIStackViewAlignment.leading
        chatStackView.spacing   = 5.0
        chatStackView.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    
    func MakeChatTextLabelWithText(text:String) {
        
        let textLabel = TTTAttributedLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))         //textLabel.backgroundColor = UIColor.yellow
        textLabel.widthAnchor.constraint(equalToConstant: self.chatStackView.frame.width-10).isActive = true
        textLabel.delegate = self
        //textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        textLabel.text  = "Hi World END gjhgasjdgsakjdsadkjasgdkas kgjjasgdksadg sakdgkgk kasd askdgask dgsakdk gdaskd kasgdkas d gaskd askgdgaskdgkasgd askdgas dkasgdas"
//        textLabel.textAlignment = .natural
//        textLabel.lineBreakMode = .byWordWrapping
        //textLabel.numberOfLines = 0
        
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.sizeToFit()
        chatStackView.addArrangedSubview(textLabel)
    }
    
    func addRadioButtonsWithTitle(count:Int){
         for i in 0..<count{
            let button = makeButtonWithText(tag: i)
            let lable = makeTextLableWithText(index: i)
            var viewArray = [UIView]()
            viewArray += [button]
            viewArray += [lable]
            let stackView = UIStackView(arrangedSubviews: viewArray)
            stackView.spacing = 10.0

            chatStackView.addArrangedSubview(stackView)
         }
    }
    
    
    func makeButtonWithText(tag:Int) -> KGRadioButton {
        //Initialize a button
        let myButton = KGRadioButton()
        myButton.tag = tag
        //myButton.frame = CGRect(x: 30, y: 0, width: 25, height: 25)
        myButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        myButton.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        //myButton.widthAnchor.constraint(equalToConstant: 25)
        myButton.outerCircleColor = UIColor(red: 0.0/255, green: 122.0/255, blue: 255.0/255, alpha: 1)
        myButton.addTarget(self,action:#selector(manualAction(sender:)) ,for: .touchUpInside)
        return myButton
    }
    
    func makeTextLableWithText(index:Int) -> UILabel {
        print(index)
        let textTitleLabel = UILabel()
        textTitleLabel.widthAnchor.constraint(equalToConstant: self.chatStackView.frame.width-30).isActive = true
        textTitleLabel.font = UIFont.systemFont(ofSize: 14)
        textTitleLabel.text = optionData[index]
        return textTitleLabel
    }
        
    func manualAction (sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            self.delegate?.SendMessageWithButtonValue(with: optionData[sender.tag])
            
        } else{
        }
    }

        //setupHyperLinks()
    //}


    
    
    
    
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.chatBubbleTableView.rowHeight = UITableViewAutomaticDimension
        //self.chatBubbleTableView.estimatedRowHeight = 1000
        //self.chatBubbleTableView.isScrollEnabled = false
        //tableView.backgroundColor = UIColor.white
        //self.chatBubbleTableView.register(UINib(nibName: "ChatTextCell", bundle: nil), forCellReuseIdentifier: "ChatTextCell")
        //self.chatBubbleTableView.reloadData()
        //self.chatBubbleTableView.register(UINib(nibName: "StoriesTextCell", bundle: nil), forCellReuseIdentifier: "StoriesTextCell")
        // Initialization code
    }
    
    
    
    
    
   // @IBOutlet weak var autoTableView: UITableView!
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 3//self.itemValue.count
    }
    
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var textCell: ChatTextCell!
        var buttonCell : ChatButtonCell!
        if indexPath.row == 0 {
            if (textCell == nil) {
                textCell = (tableView.dequeueReusableCell(withIdentifier: "ChatTextCell") as? ChatTextCell)!
            }
            textCell.selectionStyle = UITableViewCellSelectionStyle.none
            textCell.messageLabel.text = "fdsfsdfdsfsdfsdfsdfsdfsdfsdfsdfsdfsfsfsfsdfsdfdsfdsfdsfsdKSADASAADASDASDASdsaFDFDSFDSFSDFEWfwfwefwefewfwwefwefwwfwefwfewfewfewfwefwefwfwefwefewfwefewfwefwefwefwefwefwgrtgregfsvsdfgdscdsfddadfasfefasftewfafewfdfewgwegewrgwegergwegregwwegwrgEND"
            return textCell
        }
        else{
            if (buttonCell == nil) {
                buttonCell = (tableView.dequeueReusableCell(withIdentifier: "ChatButtonCell") as? ChatButtonCell)!
            }
            buttonCell.selectionStyle = UITableViewCellSelectionStyle.none
            buttonCell.optionLable.text = "test option"
            buttonCell.buttonOptions?.tag = indexPath.row-1
            
            
            
            
            return buttonCell
        }
        
        
    }
    
    
func alert(_ title: String, message: String) {

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
