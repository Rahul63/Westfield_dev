//
//  UserChatViewCell.swift
//  WatsonDemo
//
//  Created by Etay Luz on 11/13/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

import UIKit

class UserChatViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var buttonsView: ButtonsView!
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rightTriangleView: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    var callValue : Bool = true
    


    // MARK: - Constraints
    @IBOutlet weak var buttonsLeadingConstraint: NSLayoutConstraint!

    // MARK: - Properties
    var chatViewController: ChatViewController?
    var initialButtonsLeadingConstraint: CGFloat!
    var message: Message?

    /// Configure user chat table view cell with user message
    ///
    /// - Parameter message: Message instance
    func configure(withMessage message: Message) {
        self.message = message

        if var text = message.text,
            text.characters.count > 0 {
//            print("My final text..>text")
//            text = text.replacingOccurrences(of: "<br>", with: "\n")
            
            messageLabel.text = text
        }

        buttonsView.configure(withOptions: nil,
                              viewWidth: buttonsView.frame.width,
                              userChatViewCell: self)

        initialButtonsLeadingConstraint = initialButtonsLeadingConstraint ?? buttonsLeadingConstraint.constant
        buttonsLeadingConstraint.constant = initialButtonsLeadingConstraint + (buttonsView.viewWidth - buttonsView.maxX)/2

//        messageBackground.isHidden = message.options != nil ? true : false
//        messageLabel.isHidden = message.options != nil ? true : false
//        rightTriangleView.isHidden = message.options != nil ? true : false
//        userIcon.isHidden = message.options != nil ? true : false
//        userIcon.layer.cornerRadius = userIcon.frame.width / 2
//        userIcon.clipsToBounds = true
    }

    // MARK: - Actions
    func optionButtonTapped(withSelectedButton selectedButton: String) {

        message?.options = nil
        message?.text = selectedButton
        
       

        /// Update message
        if let indexPath = chatViewController?.chatTableView.indexPath(for: self),
           let message = message {
            chatViewController?.messages[indexPath.row] = message
            chatViewController?.dismissKeyboard()
        }

        userIcon.isHidden = false
       // addSubview(selectedButton)
 //       buttonsView.reset()

//        selectedButton.frame = CGRect(x: selectedButton.frame.origin.x + buttonsView.frame.origin.x,
//                                      y: selectedButton.frame.origin.y + buttonsView.frame.origin.y,
//                                      width: selectedButton.frame.size.width,
//                                      height: selectedButton.frame.size.height)
//        selectedButton.setTitleColor(UIColor.black, for: UIControlState.normal)
//        selectedButton.setTitleColor(UIColor.black, for: UIControlState.highlighted)
//        selectedButton.backgroundColor = UIColor.white
//        selectedButton.translatesAutoresizingMaskIntoConstraints = false
//        selectedButton.trailingAnchor.constraint(equalTo: userIcon.leadingAnchor, constant: -15).isActive = true
//        selectedButton.centerYAnchor.constraint(equalTo: userIcon.centerYAnchor).isActive = true
//        selectedButton.widthAnchor.constraint(equalToConstant: selectedButton.frame.width).isActive = true

        UIView.animate(withDuration: 0.5, delay: 0, animations: { [weak self] in
            self?.layoutIfNeeded()
        }, completion: { result in
           // selectedButton.removeFromSuperview()
            //self.reloadCell()
             //self.messageLabel.text = selectedButton
//            let userMessage = Message(type: MessageType.User, text: selectedButton, options: nil)
//            self.chatViewController?.appendChat(withMessage: userMessage)
            
           // self.chatViewController?.conversationService.sendMessage(withText: (selectedButton))
        })
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // print("Notifican adding call")
//        NotificationCenter.default.removeObserver(self)
//        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "ChatfieldShouldRefresh"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateChatField), name: NSNotification.Name(rawValue: "ChatfieldShouldRefresh"), object: nil)
    }
    
    func updateChatField(notification: NSNotification) {
        //NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "ChatfieldShouldRefresh"), object: nil)
        //NSLog("Object is %@", notification.value(forKey: "object") as! String!)
        
        let value = notification.value(forKey: "object") as! String!
        
        self.optionButtonTapped(withSelectedButton: value!)
        
        //let userMessage = Message(type: MessageType.User, text: messsage, options: nil)
        // self.chatViewController.appendChat(withMessage: userMessage)
        //sendMessage()
    }

    // MARK: - Private
    /// Once the user has tapped an option button, the cell needs to be resized and so we reload it to shrink it
    private func reloadCell() {
        // This is needed to resize the ButtonsView correctly
        if let indexPath = self.chatViewController?.chatTableView.indexPath(for: self) {
            self.chatViewController?.chatTableView.reloadRows(at: [indexPath], with: .none)
            self.chatViewController?.scrollChatTableToBottom()
        }
    }


}
