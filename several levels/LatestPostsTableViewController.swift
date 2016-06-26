//
//  LatestPostsTableViewController.swift
//  several levels
//
//  Created by Harrison McGuire on 6/7/16.
//  Copyright © 2016 severallevels. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class LatestPostsTableViewController: UITableViewController {
    

    let latestPosts : String = "https://severallevels.io/wp-json/wp/v2/posts/"
    
    let tuts: String = "https://severallevels.io/wp-json/wp/v2/posts//?filter[category_name]=tutorials"
    
    @IBOutlet var controller: UIBarButtonItem!
    
    let parameters: [String:AnyObject] = ["filter[posts_per_page]" : 100]
    var json : JSON = JSON.null
    var preventAnimation = Set<NSIndexPath>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.backgroundView = UIImageView(image:UIImage(named:"background"))
        
        
        //create a new button
        //let button: UIButton = UIButtonType(rawValue: UIButtonType.Custom)
        //set image for button
        //button.setImage(UIImage(named: "fb.png"), forState: UIControlState.Normal)
        //add function for button
        
//        let backImg: UIImage = UIImage(named: "Home")!
//        controller.setBackgroundImage(backImg, forState: .Normal, barMetrics: .Default)
        let barButton = UIBarButtonItem(image: UIImage(named: "Home"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(newNews))
        //self.navigationItem.leftBarButtonItem = barButton
        self.toolbarItems?.append(barButton)
        
//        controller.target.self
//        controller.action("sayHello")
//        
//        button.addTarget(self, action: "fbButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
//        //set frame
//        button.frame = CGRectMake(0, 0, 53, 31)
//        
//        let barButton = UIBarButtonItem(customView: button)
//        //assign button to navigationbar
//        self.navigationItem.rightBarButtonItem = barButton
        
        
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 39/255, green: 207/255, blue: 230/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(LatestPostsTableViewController.newNews), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        getPosts(latestPosts)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    
    func newNews() {
        getPosts(latestPosts)
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }    
    
    @IBAction func sortTutorials(sender: UIBarButtonItem) {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        delay(0.25) {
            self.preventAnimation.removeAll()
            self.getPosts(self.tuts)
            self.tableView.hidden = false
        }
    }
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    func getPosts(getposts : String) {
        
          Alamofire.request(.GET, getposts, parameters: parameters).responseJSON { response in
                
                guard let data = response.result.value else{
                    print("Request failed with error")
                    return
                }
                
                self.json = JSON(data)
                self.tableView.reloadData()
                
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            TipInCellAnimator.animate(cell)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.json.type {
            case Type.Array:
                return self.json.count
            default:
                return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! LatestPostsTableViewCell
        
        // Get row index
        let row = indexPath.row
            
        cell.mainView.layer.cornerRadius = 10
        cell.mainView.layer.masksToBounds = true
        
        //Make sure post title is a string
        if let title = self.json[row]["title"]["rendered"].string {
            cell.postTitle!.text = title
        }
        
        //Make sure post date is a string
        if self.json[row]["date"].string != nil {
            let dateString = self.json[row]["date"].string
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let dateObj = dateFormatter.dateFromString(dateString!)
            
            dateFormatter.dateFormat = "MM-dd-yyyy"
            
            let dateStringConverted = "\(dateFormatter.stringFromDate(dateObj!))"
            
            cell.postDate!.text = dateStringConverted
        }
        
        if let featureImage = self.json[row]["featured_image_url"].string {
            let image : NSURL? = NSURL(string: featureImage)
            cell.postImage.sd_setImageWithURL(image)
        }
        
        return cell
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // which view controller to send to 
        let postScene = segue.destinationViewController as! WebViewController;
        
        // pass the selected JSON to the 'viewPost varible of the WebViewController Class
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let selected = self.json[indexPath.row]
            postScene.viewPost = selected
        }
        
    }

}