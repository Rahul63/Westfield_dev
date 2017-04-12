//
//  ChatViewController.swift
//  WatsonDemo
//
//  Created by Etay Luz on 11/13/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

import AVFoundation
import UIKit
import UserNotifications
import TextToSpeechV1

class ChatViewController: UIViewController,watsonChatCellDelegate {

    // MARK: - Constants
    private struct Constants {
        static let conversationKickoffMessage = "Hi"
    }

    @IBOutlet weak var chatTableHeight: NSLayoutConstraint!
    // MARK: - Outlets
    @IBOutlet weak var chatTableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTextField: ChatTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var micImage: UIImageView!
    let sharedInstnce = watsonSingleton.sharedInstance
    // MARK: - Properties
    var audioPlayer = AVAudioPlayer()
    var messages = [Message]()

    // MARK: - Services
    lazy var conversationService: ConversationService = ConversationService(delegate:self)
    lazy var speechToTextService: SpeechToTextService = SpeechToTextService(delegate:self)
    lazy var textToSpeechService: TextToSpeechService = TextToSpeechService(delegate:self)

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let username = "7d80a6ad-74ee-4564-9f5f-3bc54324028e"
        let password = "tYVex8dIA4xy"
        let textToSpeech = TextToSpeech(username: username, password: password)
        
//        let text = "All the problems of the world could be settled easily if men were only willing to think."
//        let failure = { (error: Error) in print(error) }
//        textToSpeech.synthesize(text, failure: failure) { data in
//            self.audioPlayer = try! AVAudioPlayer(data: data)
//            self.audioPlayer.play()
//        }
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(updateChatField), name: NSNotification.Name(rawValue: "ChatfieldShouldRefresh"), object: nil)
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: [.alert,.sound,.badge],
//                completionHandler: { (granted,error) in
//                    self.isGrantedNotificationAccess = granted
//            }
//            )
//        } else {
//            // Fallback on earlier versions
//        }
        
        self.headerView.backgroundColor = UIColor(netHex:0xd89c54)
        setupSimulator()
        chatTextField.chatViewController = self
        

        chatTableView.autoresizingMask = UIViewAutoresizing.flexibleHeight;
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 140

        // We need to send some dummy text to keep off the conversation
        conversationService.getValues()

        let gestureTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        gestureTap.cancelsTouchesInView = false
        chatTableView.addGestureRecognizer(gestureTap)
        
        
        
//        let recentsItem = self.tabBarController!.tabBar.items![0] as UITabBarItem
//        let recentsItemImage = UIImage(named:"advice_icon.png")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//        let recentsItemImageSelected = UIImage(named: "advice_icon")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//        recentsItem.image = recentsItemImage
//        recentsItem.selectedImage = recentsItemImageSelected
        
        
        
        
        
    }
    
//    func updateChatField(notification: NSNotification) {
//        NSLog("Object is %@", notification.value(forKey: "object") as! String!)
//    }
    
//    func updateChatField()  {
//        //
//    }

    // MARK: - Actions
    @IBAction func micButtonTapped() {
        
        
        if micButton.isSelected {
            micImage.image = UIImage.init(imageLiteralResourceName: "Mic_iconOff")
            speechToTextService.finishRecording()
        } else {
            micImage.image = UIImage.init(imageLiteralResourceName: "Mic_iconOn")
            if sharedInstnce.isVoiceOn == true {
                if audioPlayer.isPlaying{
                    audioPlayer.stop()
                }
                
            }
            
            speechToTextService.startRecording()
        }

        micButton.isSelected = !micButton.isSelected
    }
    
    
    @IBAction func SignOutButtonPressed(_ sender: Any) {
        if (sharedInstnce.isVoiceOn == true){
            if audioPlayer.isPlaying{
                audioPlayer.stop()
            }
        }
        
        
       // UserDefaults.standard.setValue("", forKey: "UserDetail")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let logInVc = storyBoard.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = logInVc

        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (sharedInstnce.isVoiceOn == true){
            do {
            if audioPlayer.isPlaying{
                audioPlayer.stop()
            }
        }
        
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (sharedInstnce.isVoiceOn == true){
            if let url = Bundle.main.url(forResource: "Test", withExtension: "m4a"){
                audioPlayer = try! AVAudioPlayer(contentsOf: url)
            }
        }
    }


    /// Dismiss keyboard on screen tap
    func dismissKeyboard() {
        chatTableBottomConstraint.constant = 0
        view.endEditing(true)
    }

    func appendChat(withMessage message: Message) {
        
        guard let text = message.text,
            (text.characters.count > 0 || message.options != nil ||
             message.mapUrl != nil || message.videoUrl != nil || message.imageUrl != nil)
            else { return }


        if message.type == MessageType.User && text.characters.count > 0 {
            conversationService.sendMessage(withText: text)
        }

        if let _ = messages.last?.options {
            /// If user speak or types instead of tapping option button, reload that cell
            let indexPath = NSIndexPath(row: messages.count - 1, section: 0) as IndexPath
            messages[messages.count - 1] = message
            chatTableView.reloadRows(at: [indexPath], with: .none)
        } else {
            messages.append(message)
            /// Add new row to chatTableView
            let indexPath = NSIndexPath(row: messages.count - 1, section: 0) as IndexPath
            chatTableView.beginUpdates()
            chatTableView.insertRows(at: [indexPath], with: .none)
            chatTableView.endUpdates()
            let when = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: when + 0.1) {
                self.scrollChatTableToBottom()
            }
        }

        //self.chatTableView.reloadData()
    }

    func scrollChatTableToBottom() {
        guard self.messages.count > 0 else { return }

        let indexPath = NSIndexPath(row: self.messages.count - 1, section: 0) as IndexPath
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        //self.chatTableView.reloadData()
    }

    // MARK: - Private
    // This will only execute on the simulator and NOT on a real device
    private func setupSimulator() {
        #if DEBUG

        #endif
    }
    
    func SendMessageWithButtonValue(with value:String){
       // print(value)
        
        let userMessage = Message(type: MessageType.User, text: value, options: nil)
        self.appendChat(withMessage: userMessage)

        
    }
    
    
    
    func loadUrlLink(url : String?){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVc = storyBoard.instantiateViewController(withIdentifier: "WatsonChatDetailViewController") as! WatsonChatDetailViewController
        detailVc.urlStr = url
        
        self.navigationController?.pushViewController(detailVc, animated: true)
        
//            let vc = UIAlertController(title: "", message: url, preferredStyle: UIAlertControllerStyle.alert)
//            vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
       // self.present(detailVc, animated: false, completion: nil)

    }

}
// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        switch message.type {
        case MessageType.Map:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MapViewCell.self),
                                                     for: indexPath) as! MapViewCell
            cell.configure(withMessage: message)
            return cell

        case MessageType.Watson:
            //var cell : WatsonChatViewCell!
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WatsonChatViewCell.self),
                                                         for: indexPath) as! WatsonChatViewCell
            
            cell.delegate = self
            cell.configure(withMessage: message)
//             print("myLabel Posion..CHHAATT..\(cell.heightLable.frame.maxY,cell.heightLable.frame,cell.contentView.frame)")
            return cell

        case MessageType.User:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserChatViewCell.self),
                                                     for: indexPath) as! UserChatViewCell
            cell.configure(withMessage: message)
            cell.chatViewController = self
            return cell

        case MessageType.Video:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoViewCell.self),
                                                     for: indexPath) as! VideoViewCell
            cell.configure(withMessage: message)
            cell.chatViewController = self
            return cell
        
        case MessageType.image:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MapViewCell.self),
                                                     for: indexPath) as! MapViewCell
            cell.configure(withMessage: message)
            return cell
        }

    }

}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]

        if message.type == MessageType.image {
            return 240
        }

        if message.type == MessageType.Video {
            return UIScreen.main.bounds.size.width * 0.76
        }

        return UITableViewAutomaticDimension
    }
    
}

//func updateViewConstraints() {
//   // super.updateViewConstraints()
//    //tableHeightConstraint.constant = tableView.contentSize.height
//}

// MARK: - SpeechToTextServiceDelegate
extension ChatViewController: SpeechToTextServiceDelegate {

    func didFinishTranscribingSpeech(withText text: String) {
        appendChat(withMessage: Message(type: MessageType.User, text: text, options: nil))
    }
    
}

// MARK: - TextToSpeechServiceDelegate
extension ChatViewController: TextToSpeechServiceDelegate {

    func textToSpeechDidFinishSynthesizing(withAudioData audioData: Data) {
        audioPlayer = try! AVAudioPlayer(data: audioData)
        #if !DEBUG
            
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            } catch _ {
            }
            audioPlayer.play()
        #endif
    }
    
}

// MARK: - ConversationServiceDelegate
extension ChatViewController: ConversationServiceDelegate {
    
    internal func didReceiveMessage(withText text: String, options: [String]?) {
        guard text.characters.count > 0 else { return }
        
        var opt = [String]()
        
        print("<<<<<<<<<<<<<<<<<<<\(sharedInstnce.isVoiceOn)")
        if (sharedInstnce.isVoiceOn == true){
            
            let rangeN = text.range(of:"\",\"", options:.regularExpression)
            if (rangeN != nil) {
                let textN = text.replacingOccurrences(of: "\",\"", with: "n&n")
                opt = textN.components(separatedBy: "n&n")
                //print("my Watson message>>>>>>>>>>>>>>>>>>>\(textN)")
                //print("my Watson message>>>>>>>>>>>>>>>>>>>\(opt)")
                var foundText = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])")
                let nsString = foundText as NSString
                if let result = regex.matches(in: foundText, range: NSRange(location: 0, length: nsString.length)).last {
                    let optionsString = nsString.substring(with: result.range)
                    foundText = foundText.replacingOccurrences(of: optionsString, with: "")
                    print("With url.Newchat.\(foundText)")
                    //self.textToSpeechService.synthesizeSpeech(withText: foundText)
                }else{
                    print("With Normal new Chat..\(foundText)")
                    //self.textToSpeechService.synthesizeSpeech(withText: foundText)
                }
                for item in 0..<opt.count{
                    self.appendChat(withMessage: Message(type: MessageType.Watson, text: opt[item], options: nil))
                }
                
            }else{
                
                var foundText = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])")
                let nsString = foundText as NSString
                if let result = regex.matches(in: foundText, range: NSRange(location: 0, length: nsString.length)).last {
                    let optionsString = nsString.substring(with: result.range)
                    print("With optionsString..\(optionsString)")
                    foundText = foundText.replacingOccurrences(of: optionsString, with: "")
                    print("With url..\(foundText)")
                    //self.textToSpeechService.synthesizeSpeech(withText: foundText)
                }else{
                    print("With Normal..\(foundText)")
                   // self.textToSpeechService.synthesizeSpeech(withText: foundText)
                }
                //self.textToSpeechService.synthesizeSpeech(withText: foundText)
                self.appendChat(withMessage: Message(type: MessageType.Watson, text: text, options: nil))
            }
            
        }else{
            
            
            let rangeN = text.range(of:"\",\"", options:.regularExpression)
            if (rangeN != nil) {
                let textN = text.replacingOccurrences(of: "\",\"", with: "n&n")
                opt = textN.components(separatedBy: "n&n")
                var foundText = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])")
                let nsString = foundText as NSString
                if let result = regex.matches(in: foundText, range: NSRange(location: 0, length: nsString.length)).last {
                    let optionsString = nsString.substring(with: result.range)
                    foundText = foundText.replacingOccurrences(of: optionsString, with: "")
                    print("With url.Newchat.\(foundText)")
                }else{
                    print("With Normal new Chat..\(foundText)")
                }
                for item in 0..<opt.count{
                    //                 let foundText = opt[item].replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    //
                    //                self.textToSpeechService.synthesizeSpeech(withText: foundText)
                    self.appendChat(withMessage: Message(type: MessageType.Watson, text: opt[item], options: nil))
                }
                
            }else{
                
                var foundText = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])")
                let nsString = foundText as NSString
                if let result = regex.matches(in: foundText, range: NSRange(location: 0, length: nsString.length)).last {
                    let optionsString = nsString.substring(with: result.range)
                    print("With optionsString..\(optionsString)")
                    foundText = foundText.replacingOccurrences(of: optionsString, with: "")
                    print("With url..\(foundText)")
                   // self.textToSpeechService.synthesizeSpeech(withText: foundText)
                }else{
                    print("With Normal..\(foundText)")
                    //self.textToSpeechService.synthesizeSpeech(withText: foundText)
                }
                //self.textToSpeechService.synthesizeSpeech(withText: foundText)
                self.appendChat(withMessage: Message(type: MessageType.Watson, text: text, options: nil))
            }
            
        }
        
        
//        if let _ = options {
//            self.appendChat(withMessage: Message(type: MessageType.User, text: "", options: options))
//        }

    }
    
    internal func didReceiveMessageForTexttoSpeech(withText text: String){
        
        var foundText = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let regex = try! NSRegularExpression(pattern: "([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])")
        let nsString = foundText as NSString
        if let result = regex.matches(in: foundText, range: NSRange(location: 0, length: nsString.length)).last {
            let optionsString = nsString.substring(with: result.range)
            print("With optionsString..\(optionsString)")
            foundText = foundText.replacingOccurrences(of: optionsString, with: "")
        }else{
            foundText = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        }
        print("<<<<<<<<NEWW<<<<<<<<<<<\(sharedInstnce.isVoiceOn)")
        if (sharedInstnce.isVoiceOn == true){
            
            self.textToSpeechService.synthesizeSpeech(withText: foundText)
        }
    }

    internal func didReceiveMap(withUrl mapUrl: URL) {
        var message = Message(type: MessageType.Map, text: "", options: nil)
        message.mapUrl = mapUrl
        self.appendChat(withMessage: message)
    }

    internal func didReceiveVideo(withUrl videoUrl: URL) {
        var message = Message(type: MessageType.Video, text: "", options: nil)
        message.videoUrl = videoUrl
        self.appendChat(withMessage: message)
    }

    internal func didReceiveImage(withUrl imageUrl: URL) {
        var message = Message(type: MessageType.image, text: "", options: nil)
        message.imageUrl = imageUrl
        self.appendChat(withMessage: message)
    }

}
