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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set user agent
        NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent": "several-levels"])
        
        // make sure post url is as string
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
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
