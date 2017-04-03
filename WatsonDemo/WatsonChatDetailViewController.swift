//
//  WatsonChatDetailViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/22/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class WatsonChatDetailViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var detailWebView: UIWebView!
    var urlStr: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("myUrl>>>>>>\(urlStr)")
        
        let videoID = self.extractYoutubeIdFromLink(link: urlStr!)
        
        if videoID != nil{
            detailWebView.allowsInlineMediaPlayback = true
            detailWebView.mediaPlaybackRequiresUserAction = false
            print(videoID!)
            // get the ID of the video you want to play
             //videoID = "Km8XxRCuCho" // https://www.youtube.com/watch?v=zN-GGeNPQEg
            
            // Set up your HTML.  The key URL parameters here are playsinline=1 and autoplay=1
            // Replace the height and width of the player here to match your UIWebView's  frame rect
            let embededHTML = "<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(self.view.frame.size.width)' height='\(self.view.frame.size.height)' src='http://www.youtube.com/embed/\(videoID!)?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'></body></html>"
            
            // Load your webView with the HTML we just set up
            detailWebView.loadHTMLString(embededHTML, baseURL: Bundle.main.bundleURL)
            
        }else{
            detailWebView.loadRequest(NSURLRequest(url: NSURL(string: urlStr!)! as URL) as URLRequest)
        }
        
        
        
        
        
        
        //detailWebView.loadRequest(NSURLRequest(url: NSURL(string: urlStr!)! as URL) as URLRequest)
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        
        _=self.navigationController?.popViewController(animated: true)
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView){
        self.activityIndicator.startAnimating()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        self.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.activityIndicator.stopAnimating()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
