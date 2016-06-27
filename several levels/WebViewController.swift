//
//  WebViewController.swift
//  several levels
//
//  Created by Harrison McGuire on 6/13/16.
//  Copyright © 2016 severallevels. All rights reserved.
//

import UIKit
import SwiftyJSON

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var viewPost : JSON = JSON.null
    
    @IBOutlet var myProgressView: UIProgressView!
    
    var theBool: Bool = false
    var myTimer: NSTimer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set user agent
        NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent": "several-levels"])
        
        navigationController?.hidesBarsOnSwipe = true
        
        loadPage()
    }
    
    func loadPage() {
        if let postLink = self.viewPost["link"].string {
            // convert url stirng to NSURL object
            let requestURL = NSURL(string: postLink)
            
            // create request from NSURL
            let request = NSURLRequest(URL: requestURL!)
            
            webView.delegate = self
            
            // load the post
            webView.loadRequest(request)
            
            // set title of navbar to title of wordpress post
            if let title = self.viewPost["title"].string {
                self.title = title
                print(title)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        startProgressBar()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        endProgresBar()
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        myProgressView.hidden = false
        loadPage()
    }
    
    func startProgressBar() {
        self.myProgressView.progress = 0.0
        self.theBool = false
        self.myTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(WebViewController.timerCallback), userInfo: nil, repeats: true)
    }
    
    func endProgresBar() {
        self.theBool = true
    }
    
    func timerCallback() {
        if self.theBool {
            if self.myProgressView.progress >= 1 {
                self.myProgressView.hidden = true
                self.myTimer.invalidate()
            } else {
                self.myProgressView.progress += 0.1
            }
        } else {
            self.myProgressView.progress += 0.05
            if self.myProgressView.progress >= 0.75 {
                self.myProgressView.progress = 0.75
            }
        }
    }
    
    func displayShareSheet(shareContent:NSURL) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSURL], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        if let shareUrl = NSURL(string: self.viewPost["link"].string!) {
            displayShareSheet(shareUrl)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
