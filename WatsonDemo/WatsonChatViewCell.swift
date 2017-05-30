//
//  WatsonChatViewCell.swift
//  WatsonDemo
//
//  Created by RAHUL on 11/13/16.
//  Copyright © 2016 RAHUL. All rights reserved.
//

import TTTAttributedLabel
import UIKit
import AVFoundation


protocol watsonChatCellDelegate
{
    func loadUrlLink(url : String?)
    func SendMessageWithButtonValue(with value:String, atIndex : Int)
    
}

class WatsonChatViewCell: UITableViewCell {
   // let buttonOptions = KGRadioButton()
    var delegate: watsonChatCellDelegate!
    @IBOutlet weak var chatBubbleTableView: UITableView!
    @IBOutlet weak var chatStackView: UIStackView!
    var indexNumber : Int!
    
    

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
    var isbuttonEnable : Bool = true
    var selectedButtonTitle : String? = ""
    
    var chatViewController: ChatViewController?
    /// Configure Watson chat table view cell with Watson message
    ///
    /// - Parameter message: Message instance
    func configure(withMessage message: Message) {
        self.addItemsInStckView()
        
        var text = message.text!
        messageLabel.delegate = self
        self.isbuttonEnable = message.isEnableRdBtn
        self.selectedButtonTitle = message.selectedOption
        for aView in chatStackView.arrangedSubviews{
            if aView .isKind(of: UIStackView.self) {
                chatStackView.removeArrangedSubview(aView)
                aView.removeFromSuperview()
            }
        }
        
        if text.contains("</sub>"){
            
            var foundText = ""
            
            let range2 = text.range(of: "(?<=<sub alias=)[^><]+(?=>)", options: .regularExpression)
            if range2 != nil {
                var correctedArray = [String]()
                let nsString = text as NSString
                let regex = try! NSRegularExpression(pattern: "(?<=<sub alias=)[^><]+(?=>)")
                for text in regex.matches(in: text, range: NSRange(location: 0, length: nsString.length)) {
                    print(text.numberOfRanges)
                    for i in 0..<text.numberOfRanges{
                        let  rangg = text.rangeAt(i)
                        
                        var stringST = nsString.substring(with: rangg)
                        stringST = stringST.replacingOccurrences(of: "\"", with: "")
                        stringST = stringST.replacingOccurrences(of: "\\", with: "")
                       // print(stringST)
                        correctedArray.append(stringST)
                        
                    }
                }
                foundText = text
                
                if correctedArray.count>0{
                    
                    for i in 0..<correctedArray.count{
                        let rangeText2 = foundText.range(of:"<sub[^>]*>(.*?)</sub>", options:.regularExpression)
                        print(i)
                        if rangeText2 != nil {
                            let optionsStringNew = foundText.substring(with: rangeText2!)
                            print(optionsStringNew)
                            let replaceStr = optionsStringNew.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                            foundText = foundText.replacingOccurrences(of: optionsStringNew, with: replaceStr)
                            //print(foundText)
                            //print(text)
                            text = foundText
                            
                        }
                    }
                }
                
            }
            
        }
        var range1: NSRange? = nil
        text = text.replacingOccurrences(of: "<br>", with: "\n")
        optionData.removeAll()
        text = text.replacingOccurrences(of: "\",\"", with: "\n\n")

        let nsString = text as NSString
        let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])")
        
        if let result = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length)).last {
            var optionsString = nsString.substring(with: result.range)
            optionsString = optionsString.replacingOccurrences(of: "\\", with: "")
            Doc.linkUrl = optionsString
            text = text.replacingOccurrences(of: optionsString, with: "")
            let range = text.range(of:"<a[^>]*>(.*?)</a>", options:.regularExpression)
            if range != nil {
                let found = text.substring(with: range!)
                let foundStr = found.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                text = text.replacingOccurrences(of: found, with: foundStr)
                let nsText = text as NSString
                range1 = nsText.range(of: foundStr)
            }
        }
        
        var foundNew = text
        
        let rangeNew = foundNew.range(of:"(?=<)[^.]+(?=>)", options:.regularExpression)
        let rangeNew2 = foundNew.range(of:"(?=<)[^.]+(?=<\\)", options:.regularExpression)
        if (rangeNew != nil || rangeNew2 != nil) {
            let subString = foundNew.substring(with: rangeNew!)
            foundNew = foundNew.replacingOccurrences(of: subString, with: "")
            if subString.contains("<wcs:input>") {
                var foundRedioBtnData = subString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                foundRedioBtnData = foundRedioBtnData.replacingOccurrences(of: "</wcs:input", with: "")
                foundRedioBtnData = foundRedioBtnData.replacingOccurrences(of: "\n\n", with: "n&n")
                optionData = foundRedioBtnData.components(separatedBy: "n&n")
            }
            
            if optionData.count>0 {
                self.addRadioButtonsWithTitle(count: optionData.count)
            }
        }
        foundNew = foundNew.replacingOccurrences(of: ">,", with: "")
        foundNew = foundNew.replacingOccurrences(of: ">", with: "")
        foundNew = foundNew.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        messageLabel.text = foundNew
        if range1 != nil{
            messageLabel.addLink(to: URL(string: Doc.linkUrl) , with: range1!)
        }
        
    
    }


    func addItemsInStckView() {
        
        chatStackView.axis  = UILayoutConstraintAxis.vertical
        chatStackView.alignment = UIStackViewAlignment.leading
        chatStackView.spacing   = 5.0
        chatStackView.translatesAutoresizingMaskIntoConstraints = false;
    }

    
    func addRadioButtonsWithTitle(count:Int){
         for i in 0..<count{
            let button = makeButtonWithText(tag: i)
            let lable = makeTextLableWithText(index: i)
            
            let btnTitle = optionData[i]
            if btnTitle.contains(self.selectedButtonTitle!){
                button.isSelected = true
            }
            
            
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
        print("ENABLE....\(isbuttonEnable)")
        let myButton = KGRadioButton()
        myButton.tag = tag
        myButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        myButton.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        //myButton.widthAnchor.constraint(equalToConstant: 25)
        myButton.outerCircleColor = UIColor(red: 0.0/255, green: 122.0/255, blue: 255.0/255, alpha: 1)
        myButton.addTarget(self,action:#selector(manualAction(sender:)) ,for: .touchUpInside)
        if isbuttonEnable == false {
            myButton.isEnabled = false
            myButton.alpha = 0.5
        }
        
        return myButton
    }
    
    func makeTextLableWithText(index:Int) -> UILabel {
        print(index)
        let textTitleLabel = UILabel()
        textTitleLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        textTitleLabel.font = UIFont.systemFont(ofSize: 14)
        textTitleLabel.text = optionData[index]
        return textTitleLabel
    }
        
    func manualAction (sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            self.delegate?.SendMessageWithButtonValue(with: optionData[sender.tag],atIndex: indexNumber)
            
        } else{
        }
    }

        //setupHyperLinks()
    //}

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
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
