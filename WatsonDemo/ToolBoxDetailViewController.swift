//
//  ToolBoxDetailViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/13/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class ToolBoxDetailViewController: UIViewController {

    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    @IBOutlet weak var loadDataWebView: UIWebView!
    var loadUrlStr : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("myyyyUURRRRRLLLLLL to load..\(loadUrlStr)")
        loadDataInWebView(linkURL: loadUrlStr!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        let image = UIImage(named: "watson_icon")
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
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
            let embededHTML = "<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(self.loadDataWebView.frame.size.width)' height='\(300)' src='http://www.youtube.com/embed/\(videoID!)?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'></body></html>"
            
            // Load your webView with the HTML we just set up
            loadDataWebView.loadHTMLString(embededHTML, baseURL: Bundle.main.bundleURL)
            
        }else{
            loadDataWebView.loadRequest(NSURLRequest(url: NSURL(string: linkURL!)! as URL) as URLRequest)
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
