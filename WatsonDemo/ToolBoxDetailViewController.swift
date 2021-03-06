//
//  ToolBoxDetailViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/13/17.
//  Copyright © 2017 RAHUL. All rights reserved.
//

import UIKit

protocol ToolBoxDetailViewDelegate
{
    func exitFullScreenVideo()
    
}

class ToolBoxDetailViewController: UIViewController {

    var documentController : UIDocumentInteractionController!
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var loadDataWebView: UIWebView!
    @IBOutlet weak var headerView: UIView!
    var helpViewBG = UIView()
    var  indicatorView = ActivityView()
    var loadUrlStr : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize: CGRect = UIScreen.main.bounds
        helpViewBG = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width , height: screenSize.height))
        helpViewBG.alpha = 0.4
        helpViewBG.backgroundColor = UIColor.darkGray
        
        indicatorView.frame = CGRect(x:0,y:0,width:50,height:50)
        indicatorView.center = CGPoint(x: self.view.frame.size.width/2,y: self.view.frame.size.height/2-100)//CGPoint(x:self.view.center,y:self.view)
        indicatorView.lineWidth = 5.0
        indicatorView.strokeColor = UIColor(red: 0.0/255, green: 122.0/255, blue: 255.0/255, alpha: 1)
        self.view.addSubview(helpViewBG)
        self.view.addSubview(indicatorView)
        helpViewBG.isHidden = true
        indicatorView.isHidden = true
        print("myyyyUURRRRRLLLLLL to load..\(loadUrlStr)")
        loadDataInWebView(linkURL: loadUrlStr!)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.playerDidFinishPlaying),name:NSNotification.Name(rawValue: "UIMoviePlayerControllerDidEnterFullscreenNotification"),object:nil)
        
       // NotificationCenter.default.addObserver(self,selector: #selector(self.playerDidFinishPlaying),name:NSNotification.Name.UIWindowDidBecomeHidden,object:nil)
        
        
       // self.view.frame(CGRect(x:0,y:0,width:self.view.frame.size.width, height:self.view.frame.size.height))
        //self.view.frame = CGRect(x:0,y:100,width:self.view.frame.size.width, height:self.view.frame.size.height-100)
       // [self.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        self.view.setNeedsDisplay()
    }
    
    func playerDidFinishPlaying() {
        print("ppppppppppppp>>>>>>>>>>>PPPPPPPPlayeeeerrrrrrrMethod")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        //let image = UIImage(named: "watson_icon")
        
        
//        let fileURL = Bundle.main.path(forResource: "Movie1", ofType: "mp4")
//        documentController = UIDocumentInteractionController.init(url: URL.init(fileURLWithPath: fileURL))
//        documentController.presentOptionsMenu(from: self.shareButton.frame, in: self.view, animated: true)
        
        // set up activity view controller
        let itemToShare = [ loadUrlStr! ]
        let activityViewController = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.addToReadingList,UIActivityType.print,UIActivityType.copyToPasteboard,UIActivityType.postToVimeo,UIActivityType.assignToContact,UIActivityType.saveToCameraRoll,UIActivityType.openInIBooks,UIActivityType.postToWeibo,UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension")]
        //activityViewController.
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            
            // Return if cancelled
            if (!success) {
                print("user clicked cancel")
                return
            }
            
            if activity == UIActivityType.mail {
                print("share throgh mail")
            }
            else if activity == UIActivityType.message {
                print("share trhought Message IOS")
            }
        
            else if activity! == UIActivityType(rawValue :"net.whatsapp.WhatsApp.ShareExtension") {
                print("activity type is whatsapp")
            }
            else if activity! == UIActivityType(rawValue :"com.google.Gmail.ShareExtension") {
                print("activity type is Gmail")
            }
            else {
                // You can add this activity type after getting the value from console for other apps.
                print("activity type is: \(activity)")
            }}
    
    }
    
    
    func loadDataInWebView(linkURL: String?) {
        let videoID = self.extractYoutubeIdFromLink(link: linkURL!)
        
        if videoID != nil{
            loadDataWebView.allowsInlineMediaPlayback = true
            loadDataWebView.mediaPlaybackRequiresUserAction = false
            print(videoID!)
            // get the ID of the video you want to play
            //videoID = "Km8XxRCuCho" // https://www.youtube.com/watch?v=zN-GGeNPQEg
            
            // Set up your HTML.  The key URL parameters here are playsinline=1 and autoplay=1
            // Replace the height and width of the player here to match your UIWebView's  frame rect
            let embededHTML = "<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(self.view.frame.size.width)' height='\(300)' src='http://www.youtube.com/embed/\(videoID!)?enablejsapi=1&rel=0&playsinline=1&autoplay=1&fs=1&showinfo=0' frameborder='0'></body></html>"
            
            // Load your webView with the HTML we just set up
            loadDataWebView.loadHTMLString(embededHTML, baseURL: Bundle.main.bundleURL)
            
        }else{
            loadDataWebView.scalesPageToFit = true
            loadDataWebView.loadRequest(NSURLRequest(url: NSURL(string: linkURL!)! as URL) as URLRequest)
        }
    }
    
    
    func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: url)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription ?? "");
            }
        }
        task.resume()
    }
    
    
    

    @IBAction func starButtonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        button.isSelected = !button.isSelected
        
        switch button.tag {
        case 1:
            starButton1.setImage(#imageLiteral(resourceName: "staer_unselected"), for: UIControlState.normal)
            starButton1.setImage(#imageLiteral(resourceName: "star"), for: UIControlState.selected)
            break
        case 2:
            starButton2.setImage(#imageLiteral(resourceName: "staer_unselected"), for: UIControlState.normal)
            starButton2.setImage(#imageLiteral(resourceName: "star"), for: UIControlState.selected)
            break
        case 3:
            starButton3.setImage(#imageLiteral(resourceName: "staer_unselected"), for: UIControlState.normal)
            starButton3.setImage(#imageLiteral(resourceName: "star"), for: UIControlState.selected)
            break
        case 4:
            starButton4.setImage(#imageLiteral(resourceName: "staer_unselected"), for: UIControlState.normal)
            starButton4.setImage(#imageLiteral(resourceName: "star"), for: UIControlState.selected)
            break
        case 5:
            starButton5.setImage(#imageLiteral(resourceName: "staer_unselected"), for: UIControlState.normal)
            starButton5.setImage(#imageLiteral(resourceName: "star"), for: UIControlState.selected)
            break
        default:
            break
            //print("Unknown language")
           // return
        }
        
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    
    func extractYoutubeIdFromLink(link: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        //self.activityIndicator.startAnimating()
        StartAnimating()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        //self.activityIndicator.stopAnimating()
        stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        //self.activityIndicator.stopAnimating()
        stopAnimating()
        
    }
    
    
    func StartAnimating() {
        helpViewBG.isHidden = false
        indicatorView.isHidden = false        
        indicatorView.startAnimating()
        
        
    }
    func stopAnimating() {
        
        helpViewBG.removeFromSuperview()
        indicatorView.stopAnimating()
        indicatorView.hidesWhenStopped = true
        
        indicatorView.removeFromSuperview()
        
        
    }
    
    
//    let imgPlay = UIImage(named:"play.png")
//    let imgPause = UIImage(named:"pause.png")
    
    @IBAction func playPauseButton(playBtn: UIButton) {
//        if toggleState == 1 {
//            //player.play()
//            toggleState = 2
//            playBtn.setImage(imgPlay,forState:UIControlState.Normal)
//        } else {
//            player.pause()
//            toggleState = 1
//            playBtn.setImage(imgPause,forState:UIControlState.Normal)
//        }
    }
    
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
//}
//
//-(void)youTubeStarted:(NSNotification *)notification{
//    // your code here
//}
//
//-(void)youTubeFinished:(NSNotification *)notification{
//    // your code here
//}
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
