//
//  VideoChatViewCell.swift
//  WatsonDemo
//
//  Created by Etay Luz on 12/7/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

import Foundation
import MediaPlayer
import AVKit
import youtube_ios_player_helper


class VideoViewCell: UITableViewCell,YTPlayerViewDelegate {

    // MARK: - Outlets


    // MARK: - Properties
    var playerViewController: AVPlayerViewController!
    var chatViewController: ChatViewController?
    var message: Message?
    var ytplayer = YTPlayerView()
    let detailWebView = UIWebView()

    // MARK: - VideoUrl
    var videoUrls = [URL]()

    // MARK: - Cell Lifecycle
    override func prepareForReuse() {
        NotificationCenter.default.removeObserver(self)
    }

    /// Configure video chat table view cell with user message
    ///
    /// - Parameter message: Message instance
    func configure(withMessage message: Message) {
        self.message = message
        
        //self.removeFromSuperview()
        for view in self.subviews
        {
            self.ytplayer.stopVideo()
            view.removeFromSuperview()
        }
        

        let urlString: String = message.videoUrl!.absoluteString
        print("VVVVIIIDDDDDEEOOO\(urlString)")
        
        let videoId = self.extractYoutubeIdFromLink(link: urlString)
        
        if videoId == nil {
//            self.ytplayer.loadVideo(byURL:urlString, startSeconds: 0.0, suggestedQuality: YTPlaybackQuality.auto)
//            self.ytplayer.playVideo()
            
            
            
            let player = AVPlayer(url: message.videoUrl!)
            
            playerViewController = AVPlayerViewController()
            playerViewController.player = player
            playerViewController.showsPlaybackControls = false
            #if DEBUG
                playerViewController.player?.volume = 0
            #endif
            playerViewController.view.frame = CGRect(x: 20,
                                                     y: 0,
                                                     width: frame.size.width - 40,
                                                     height: frame.size.height)
            self.addSubview(playerViewController.view)
            
            if videoUrls.contains(message.videoUrl!) == false {
                playerViewController.player?.play()
                videoUrls.append(message.videoUrl!)
            }
            NotificationCenter.default.addObserver(self,selector: #selector(VideoViewCell.playerDidFinishPlaying),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: player.currentItem)
            
        }else{
            
            
            detailWebView.frame = CGRect(x:20,y:0,width:frame.size.width - 40,height:frame.size.height)
            detailWebView.scrollView.isScrollEnabled = false
            let embededHTML = "<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){;}</script><iframe id='playerId' type='text/html' width='\(detailWebView.frame.size.width)' height='\(detailWebView.frame.size.height)' src='http://www.youtube.com/embed/\(videoId!)?enablejsapi=1&rel=0&playsinline=1&autoplay=1&fs=0&showinfo=0' frameborder='0'></body></html>"
            
            //a.target.playVideo()
            // Load your webView with the HTML we just set up
            detailWebView.loadHTMLString(embededHTML, baseURL: Bundle.main.bundleURL)
            detailWebView.allowsInlineMediaPlayback = true
            self.addSubview(detailWebView)
//            ytplayer.frame = CGRect(x: 20,y: 0,width: frame.size.width - 40,height: frame.size.height)
//            self.addSubview(ytplayer)
//            ytplayer.showinfo = 0
//            ytplayer.playsinline = 0
//            
//            ytplayer.delegate = self
//            //ytplayer.
//            self.ytplayer.load(withVideoId: videoId!)
            
            
        }
        
        
        
//        self.ytplayer.loadVideo(byURL:urlString, startSeconds: 0.0, suggestedQuality: YTPlaybackQuality.auto)
        //self.ytplayer.playVideo()
        


//        let player = AVPlayer(url: message.videoUrl!)
//
//        playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        #if DEBUG
//            playerViewController.player?.volume = 0
//        #endif
//        playerViewController.view.frame = CGRect(x: 20,
//                                                 y: 0,
//                                                 width: frame.size.width - 40,
//                                                 height: frame.size.height - 35)
//        self.addSubview(playerViewController.view)
//
//        if videoUrls.contains(message.videoUrl!) == false {
//            playerViewController.player?.play()
//            videoUrls.append(message.videoUrl!)
//        }

       


//        let player = AVPlayer(url: message.videoUrl!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.bounds
//        layer.addSublayer(playerLayer)
//        player.play()
//        #if DEBUG
//            player.volume = 0
//        #endif
    }
    
    func playerView(YTPlayerView: YTPlayerState, didChangeToState: YTPlayerState) {
//        switch YTPlayerState() {
//        case YTPlayerState.paused:
//            YTPlayerState.playing
//            break;
//        
//    }
    
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
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
       // self.ytplayer.playVideo()
    }

    func playerDidFinishPlaying() {
        print("videooooooEEENNDDEEDD")
//        if chatViewController?.messages.last?.type == message?.type {
//            chatViewController?.conversationService.sendMessage(withText: "-2")
//        }
    }

}
