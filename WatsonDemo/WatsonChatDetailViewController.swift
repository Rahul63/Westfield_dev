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
        
        detailWebView.loadRequest(NSURLRequest(url: NSURL(string: urlStr!)! as URL) as URLRequest)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
