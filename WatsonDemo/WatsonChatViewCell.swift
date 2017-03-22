//
//  WatsonChatViewCell.swift
//  WatsonDemo
//
//  Created by Etay Luz on 11/13/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

import TTTAttributedLabel
import UIKit


protocol watsonChatCellDelegate
{
    func loadUrlLink(url : String)
    // loadUrlLink(result: Int)
}

class WatsonChatViewCell: UITableViewCell {
    
    var delegate: watsonChatCellDelegate!

    // MARK: - Doc
    private struct Doc {
        static let employerPolicy = "https://drive.google.com/file/d/0B-UVZVvBHs8uUjJiSXJlS2NXRGxOd3YtX1cxbExhYXhfUXlz/view?usp=sharing"
        static let driverTraining = "https://drive.google.com/file/d/0B-UVZVvBHs8uQ1puaXhBYS11SFdfUHZEWXZqSFN2T29xSmMw/view?usp=sharing"
        static let vehicleInspection = "https://drive.google.com/file/d/0B-UVZVvBHs8ueVVDOHkza2hKNVNyanNZSXFUTkFpZldnSEdR/view?usp=sharing"
        static let fleetProgram = "https://drive.google.com/file/d/0B-UVZVvBHs8uRjUySlZLYS1mYTdqU3FzbkNvVzlJaTBfajBV/view?usp=sharing"
    }

    // MARK: - Outlets

    @IBOutlet weak var messageLabel: ActiveLabel!
    @IBOutlet weak var watsonIcon: UIImageView!

    /// Configure Watson chat table view cell with Watson message
    ///
    /// - Parameter message: Message instance
    func configure(withMessage message: Message) {
        
        
        
        
        var text = message.text!// "rahul , I happen to have one (insert Box link here) in my toolkit.  You will see it’s short and simple, but powerful.  Take a look at it, if you agree, place it on your letterhead, add your name and sign it. <br><br>Management commitment is step one; your employees need to take ownership as well.  As part of your training program, watch and share <a href=\\\"https://www.youtube.com/watch?v=Km8XxRCuCho\\\">this video</a> with your team. After they have watched it, conduct a brief meeting with them to share your safety policy and discuss the video with them. May I continue?"//message.text!
        
        print("My final text..>\(text)")
        
        text = text.replacingOccurrences(of: "<br>", with: "\n")
        text = text.replacingOccurrences(of: "</a>", with: " ")
        text = text.replacingOccurrences(of: "<a href=", with: "")
        text = text.replacingOccurrences(of: ">", with: " ")
        
        text = text.replacingOccurrences(of: "\"", with: "")
        text = text.replacingOccurrences(of: "\\", with: "")
        
        
        let nsString = text as NSString
        //let regex = try! NSRegularExpression(pattern: "<.*?>")
        let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])")
        
        if let result = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length)).last {
            let optionsString = nsString.substring(with: result.range)
            
            print("myOptionalString is...<<<<<<<.\(optionsString)")
            
//            text = text.replacingOccurrences(of: optionsString, with: "")
//            
//            //text = text.replacingOccurrences(of: , with: "")
//            
//            text = text.replacingOccurrences(of: "<[^>]+>", with: "'", options: .regularExpression, range: nil)
            
            print("mytext is...<<<<<<<.\(text)")
            
        }
        
        
        
        
       // messageLabel.text = text
        
        //<a href=\\\"https://www.youtube.com/watch?v=Km8XxRCuCho\\\">this video</a>
        
        let customType3 = ActiveType.custom(pattern: "https:\\") //Looks for "supports"
        messageLabel.enabledTypes.append(customType3)
        messageLabel.urlMaximumLength = 31
        messageLabel.customize { label in

            messageLabel.text = text//"Great, your team is lucky to have safety focused management. <br><br>Management commitment is step one; your employees need to take ownership as well.  As part of your training program, watch and share https://www.youtube.com/watch?v=Km8XxRCuCho this video</a> with your team. After they viewed it, have a quick toolbox talk to discuss it. May I continue?"
            messageLabel.numberOfLines = 0
            messageLabel.lineSpacing = 1
            messageLabel.font = UIFont.boldSystemFont(ofSize: 13)
            messageLabel.textColor = UIColor.gray//(red: 102.0/255, green: 117.0/255, blue: 127.0/255, alpha: 1)
            messageLabel.URLColor = UIColor.blue//(red: 85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
            messageLabel.URLSelectedColor = UIColor(red: 82.0/255, green: 190.0/255, blue: 41.0/255, alpha: 1)
            messageLabel.handleURLTap { self.alert("URL", message: $0.absoluteString) }
            
            
        }
        
        
        
        
        
        
        
        

        //setupHyperLinks()
    }

    /*private func setupHyperLinks() {
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

}
*/


func alert(_ title: String, message: String) {
//    let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//    vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    //self.present(vc, animated: true, completion: nil)
    
    self.delegate.loadUrlLink(url: message)
}
}


// MARK: - ConversationServiceDelegate
extension WatsonChatViewCell: TTTAttributedLabelDelegate {

    public func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
    }
    
}
