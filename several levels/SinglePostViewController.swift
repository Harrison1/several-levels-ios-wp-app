//
//  SinglePostViewController.swift
//  several levels
//
//  Created by Harrison McGuire on 6/8/16.
//  Copyright © 2016 severallevels. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SinglePostViewController: UIViewController, UIWebViewDelegate {
    
    lazy var json : JSON = JSON.null
    lazy var scrollView : UIScrollView = UIScrollView()
    lazy var postTitle : UILabel = UILabel()
    lazy var featuredImage : UIImageView = UIImageView()
    lazy var authorImage : UIImageView = UIImageView()
    lazy var postTime : UILabel = UILabel()
    lazy var postContent : UILabel = UILabel()
    lazy var postAuthor : UILabel = UILabel()
    lazy var postAuthorDescription : UILabel = UILabel()
    lazy var postAuthorTwitter : UILabel = UILabel()
    lazy var postAuthorYoutube : UILabel = UILabel()
    lazy var postContentWeb : UIWebView = UIWebView()
    lazy var generalPadding : CGFloat = 20
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CGRect has 4 parameters: x,y,width,height
        scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        //We don't need horizontal scrolling
        scrollView.showsHorizontalScrollIndicator = false
        
        //Add the scrollView to the Single Post View Controller
        self.view.addSubview(scrollView)
        
        if let title = json["title"]["rendered"].string {
            
            /*
             * postTitle UI Label position:
             * x = 10px, y = 20px, width = screen width - 20px, height = 1px?!
             */
            
            postTitle.frame = CGRectMake(10, generalPadding, self.view.frame.size.width - 20, 1)
            
            //Title color is black...
            postTitle.textColor = UIColor.blackColor()
            
            //Title alignment is center...
            postTitle.textAlignment = NSTextAlignment.Left
            
            //Break long titles by word wrap
            postTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            //Font size 24px...
            postTitle.font = UIFont.systemFontOfSize(24.0)
            
            //Number of line 0. Must be set to 0 to accomodate varying title lengths
            postTitle.numberOfLines = 0
            
            //Title text is the json title...
            postTitle.text = title
            
            //This is resizes the height of the title label to accomodate title text. That's why the CGRect height was set to 1px.
            postTitle.sizeToFit()
            
            //Add the postTitle UILabel to the scrollView
            self.scrollView.addSubview(postTitle)
        }
        
        if let featured = json["featured_image_url"].string {
            
            /*
             * featuredImage position:
             * x = 10px
             * y = (height of postTitle + 20px)
             * width = screen width - 20px,
             * height = 1/3 of screen height. Arbitrary.
             */
            
            featuredImage.frame = CGRect(x: 10, y: postTitle.frame.height + generalPadding, width: self.view.frame.size.width - 20, height: self.view.frame.size.height / 3)
            
            //Fill UIImageView to scale
            featuredImage.contentMode = .ScaleAspectFill
            
            //Equivelant to "overflow: hidden;"
            featuredImage.clipsToBounds = true
            
            //Load image outside main thread
            ImageLoader.sharedLoader.imageForUrl(featured, completionHandler:{(image: UIImage?, url: String) in
                self.featuredImage.image = image!
            })
            
            self.scrollView.addSubview(featuredImage)
        }
        
        if let date = json["date"].string {
            
            postTime.frame = CGRectMake(10, (generalPadding + 10 + postTitle.frame.height + featuredImage.frame.height), self.view.frame.size.width - 20, 10)
            postTime.textColor = UIColor.grayColor()
            postTime.font = UIFont(name: postTime.font.fontName, size: 12)
            postTime.textAlignment = NSTextAlignment.Left
            postTime.text = date
            
            self.scrollView.addSubview(postTime)
        }
        
//        if let content = json["content"]["rendered"].string{
//            
//            postContent.frame = CGRectMake(10, (generalPadding * 2 + postTitle.frame.height + featuredImage.frame.height + postTime.frame.height), self.view.frame.size.width - 20, 1)
//            postContent.font = UIFont.systemFontOfSize(16.0)
//            postContent.numberOfLines = 0
//            postContent.text = content
//            postContent.lineBreakMode = NSLineBreakMode.ByWordWrapping
//            postContent.sizeToFit()
//            self.scrollView.addSubview(postContent)
//            
//        }
        
        if let content = json["content"]["rendered"].string {
            
            postContentWeb.loadHTMLString(content, baseURL: nil)
            postContentWeb.frame = CGRectMake(10, (generalPadding * 2 + postTitle.frame.height + featuredImage.frame.height + postTime.frame.height), self.view.frame.size.width - 20, 1)
            postContentWeb.delegate = self
            self.scrollView.addSubview(postContentWeb)
            
        }
        
        if let author = json["author_name"].string {
            
            /*
             * postTitle UI Label position:
             * x = 10px, y = 20px, width = screen width - 20px, height = 1px?!
             */
            
            postAuthor.frame = CGRectMake(10, (generalPadding * 2 + postTitle.frame.height + featuredImage.frame.height + postTime.frame.height + postContentWeb.frame.height), self.view.frame.size.width - 20, 1)
            
            //Title color is black...
            postAuthor.textColor = UIColor.blackColor()
            
            //Title alignment is center...
            postAuthor.textAlignment = NSTextAlignment.Left
            
            //Break long titles by word wrap
            postAuthor.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            //Font size 24px...
            postAuthor.font = UIFont.systemFontOfSize(15.0)
            
            //Number of line 0. Must be set to 0 to accomodate varying title lengths
            postAuthor.numberOfLines = 0
            
            //Title text is the json title...
            postAuthor.text = "by " + author
            
            //This is resizes the height of the title label to accomodate title text. That's why the CGRect height was set to 1px.
            postAuthor.sizeToFit()
            
            //Add the postTitle UILabel to the scrollView
            self.scrollView.addSubview(postAuthor)
        }
        
    }
    
    // MARK: This method fires after all subviews have loaded
//    override func viewDidLayoutSubviews() {
//        
//        //Set variable for final height. Cast it as CGFloat
//        var finalHeight : CGFloat = 0
//        
//        //Loop through all subviews
//        self.scrollView.subviews.forEach { (subview) -> () in
//            
//            //Add each subview height to finalHeight
//            finalHeight += subview.frame.height
//        }
//        
//        //Apply final height to scrollview
//        self.scrollView.contentSize.height = finalHeight
//        
//        //NOTE: you maye need to add some padding
//        
//    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        postContentWeb.frame = CGRectMake(10, (generalPadding * 2 + postTitle.frame.height + featuredImage.frame.height + postTime.frame.height), self.view.frame.size.width - 20, postContentWeb.scrollView.contentSize.height)
        
        postAuthor.frame = CGRectMake(10, (generalPadding * 2 + postTitle.frame.height + featuredImage.frame.height + postTime.frame.height + postContentWeb.frame.height), self.view.frame.size.width - 20, postAuthor.frame.height)
        
        var finalHeight : CGFloat = 0
        self.scrollView.subviews.forEach { (subview) -> () in
            finalHeight += subview.frame.height
        }
        
        self.scrollView.contentSize.height = finalHeight
    }
    
//    func delay(delay:Double, closure:()->()) {
//        dispatch_after(
//            dispatch_time(
//                DISPATCH_TIME_NOW,
//                Int64(delay * Double(NSEC_PER_SEC))
//            ),
//            dispatch_get_main_queue(), closure)
//    }

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
