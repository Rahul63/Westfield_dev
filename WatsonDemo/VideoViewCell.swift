//
//  VideoChatViewCell.swift
//  WatsonDemo
//
//  Created by RAHUL on 12/7/16.
//  Copyright © 2016 RAHUL. All rights reserved.
//

import Foundation
import MediaPlayer
import AVKit
import youtube_ios_player_helper


class VideoViewCell: UITableViewCell,YTPlayerViewDelegate {

    // MARK: - Outlets

    var videoUrls = [URL]()

    // MARK: - Properties
    var playerViewController: AVPlayerViewController!
    var chatViewController: ChatViewController?
    var message: Message?
    var ytplayer = YTPlayerView()
    let detailWebView = UIWebView()
    var firstTimeLoad : Bool = true
    var watsonSpeaking : Bool = false
    var currentVideoType = ""

    // MARK: - VideoUrl
   // var videoUrls = [URL]()

    
    // MARK: - Cell Lifecycle
    override func prepareForReuse() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(signOutNotif), name: NSNotification.Name(rawValue : "SignOutNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(watsonSpeakingNotif), name: NSNotification.Name(rawValue : "watsonSpeakingNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(watsonStopSpeakingNotif), name: NSNotification.Name(rawValue : "watsonStopSpeakingNotification"), object: nil)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(signOutNotif), name: NSNotification.Name(rawValue : "SignOutNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(watsonSpeakingNotif), name: NSNotification.Name(rawValue : "watsonSpeakingNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(watsonStopSpeakingNotif), name: NSNotification.Name(rawValue : "watsonStopSpeakingNotification"), object: nil)
        // Initialization code
    }

    /// Configure video chat table view cell with user message
    ///
    /// - Parameter message: Message instance
    func configure(withMessage message: Message) {
        self.message = message
        for view in self.subviews
        {
            self.ytplayer.stopVideo()
            view.removeFromSuperview()
        }
         print(Array(Set(videoUrls)))

        let urlString: String = message.videoUrl!.absoluteString
        let videoId = self.extractYoutubeIdFromLink(link: urlString)
        
        if videoId == nil {
            currentVideoType = "BOX"
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
            print(Array(Set(videoUrls)))
            if videoUrls.contains(message.videoUrl!) == false {
                playerViewController.player?.play()
                playerViewController.player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 3), queue: DispatchQueue.main) { [weak self] time in
                    self?.handlePlayerStatus(time: time)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videoPlayingNotification"), object:self)
                //videoUrls.append(message.videoUrl!)
            }
            NotificationCenter.default.addObserver(self,selector: #selector(VideoViewCell.playerDidFinishPlaying),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: player.currentItem)
            
        }else{
            
            currentVideoType = "YOUTUBE"
            ytplayer.frame = CGRect(x: 20,y: 0,width: frame.size.width - 40,height: frame.size.height)
            self.addSubview(ytplayer)
            ytplayer.delegate = self
            self.ytplayer.load(withVideoId: videoId!, playerVars: ["enablejsapi":"1","showinfo":"0","rel":"0","playsinline":"1","fs":"1","autoplay":"1"])
            if videoUrls.contains(message.videoUrl!) == false {
                
               
                print(message.videoUrl ?? "")
                ytplayer.playVideo()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videoPlayingNotification"), object:self)
                //videoUrls.append(message.videoUrl!)
            }
            
            
        }
        
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .ended:
            playerDidFinishPlaying()
            ytplayer.stopVideo()
            //videoUrls.append((message?.videoUrl!)!)
            break
        case .unstarted:
            if watsonSpeaking == false{
                ytplayer.playVideo()
            }
        default:
            break
        }
    
    }
    
    func handlePlayerStatus(time: CMTime) {
        if playerViewController.player?.status == .readyToPlay {
            if watsonSpeaking{
                playerViewController.player?.pause()
            }else{
                playerViewController.player?.play()
            }
        }
        else if playerViewController.player?.status == .unknown{
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videoEndedPlayingNotification"), object:self)
        }
    }
    
    
    func startPlayback(){
        if videoUrls.contains((message?.videoUrl!)!) == false {
            
            if (currentVideoType == "BOX"){
                playerViewController.player?.play()
            }
            else{
                ytplayer.playVideo()
            }
        }
        
    }
    
    func signOutNotif() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue : "SignOutNotification"), object: nil)
        
        self.removeFromSuperview()
        //
    }
    
    func watsonSpeakingNotif() {
        watsonSpeaking = true
        if (currentVideoType == "BOX"){
            let currentPlayer = playerViewController.player
            if (currentPlayer?.isPlaying)!{
                playerViewController.player?.pause()
            }
            
        }else{
            ytplayer.stopVideo()
        }
        
    }
    
    func watsonStopSpeakingNotif() {
        
        watsonSpeaking = false
        if videoUrls.contains((message?.videoUrl!)!) == false {
            
            if (currentVideoType == "BOX"){
                playerViewController.player?.play()
            }
            else{
                ytplayer.playVideo()
            }
        }
        
        //
    }
    
    func stopPlayback() {
        //YTPlayerState.playing
        
        if (currentVideoType == "BOX"){
            //print("StopeddddBox")
            let currentPlayer = playerViewController.player
            if (currentPlayer?.isPlaying)!{
                playerViewController.player?.pause()
            }
            
        }else{
            ytplayer.stopVideo()
        }
        
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
        if videoUrls.contains((message?.videoUrl!)!) == false {
            if watsonSpeaking == false{
                ytplayer.playVideo()
            }
            
        }
    }

    func playerDidFinishPlaying() {
        let url = message?.videoUrl!
        videoUrls.append(url!)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videoEndedPlayingNotification"), object:self)
        if chatViewController?.messages.last?.type == message?.type {
            chatViewController?.conversationService.sendMessage(withText: "-2")
        }
    }

}

extension UITableViewCell{
    
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

//extension VideoViewCell: YTPlayerViewDelegate {
//    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
//        self.youtubePlayer.playVideo()
//    }
//}
