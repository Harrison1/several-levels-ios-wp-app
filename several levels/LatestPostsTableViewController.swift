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
    let inactiveColor : UIColor = UIColor(red: 188/255, green: 228/255, blue: 255/255, alpha: 1)
    
    @IBOutlet var navBarTitle: UINavigationItem!
    @IBOutlet var homeButtonIcon: UIBarButtonItem!
    @IBOutlet var sortTutorialsIcon: UIBarButtonItem!
    @IBOutlet var sortGamesIcon: UIBarButtonItem!
    @IBOutlet var sortTechIcon: UIBarButtonItem!
    
    
    
    let parameters: [String:AnyObject] = ["filter[posts_per_page]" : 100]
    
    let parametersTutorials : [String:AnyObject] = [
        "filter[category_name]" : "tutorials",
        "filter[posts_per_page]" : 100
    ]
    
    let parametersGames : [String:AnyObject] = [
        "filter[category_name]" : "games",
        "filter[posts_per_page]" : 100
    ]
    
    let parametersTech : [String:AnyObject] = [
        "filter[category_name]" : "tech",
        "filter[posts_per_page]" : 100
    ]
    
    var json : JSON = JSON.null
    var preventAnimation = Set<NSIndexPath>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 39/255, green: 207/255, blue: 230/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(LatestPostsTableViewController.newNews), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        homeButtonIcon.tintColor = UIColor.whiteColor()
        
        getPosts(latestPosts, params: parameters)
        
    }
    
    func newNews() {
        getPosts(latestPosts, params: parameters)
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
        navBarTitle.title = "several levels"
        homeButtonIcon.tintColor = UIColor.whiteColor()
    }
    
    @IBAction func homeButton(sender: AnyObject) {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        delay(0.25) {
            self.preventAnimation.removeAll()
            self.getPosts(self.latestPosts, params: self.parameters)
        }
        delay(0.75){
            self.tableView.hidden = false
        }
        navBarTitle.title = "the latest"
        homeButtonIcon.tintColor = UIColor.whiteColor()
        sortTutorialsIcon.tintColor = inactiveColor
        sortGamesIcon.tintColor = inactiveColor
        sortTechIcon.tintColor = inactiveColor
    }
    
    @IBAction func sortTutorials(sender: UIBarButtonItem) {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        delay(0.25) {
            self.preventAnimation.removeAll()
            self.getPosts(self.latestPosts, params: self.parametersTutorials)
        }
        delay(0.75){
            self.tableView.hidden = false
        }
        navBarTitle.title = "tutorials"
        sortTutorialsIcon.tintColor = UIColor.whiteColor()
        homeButtonIcon.tintColor = inactiveColor
        sortGamesIcon.tintColor = inactiveColor
        sortTechIcon.tintColor = inactiveColor
    }
    
    @IBAction func sortGames(sender: AnyObject) {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        delay(0.25) {
            self.preventAnimation.removeAll()
            self.getPosts(self.latestPosts, params: self.parametersGames)
        }
        delay(0.75){
            self.tableView.hidden = false
        }
        navBarTitle.title = "games"
        sortGamesIcon.tintColor = UIColor.whiteColor()
        homeButtonIcon.tintColor = inactiveColor
        sortTutorialsIcon.tintColor = inactiveColor
        sortTechIcon.tintColor = inactiveColor
        
    }
    
    
    @IBAction func sortTech(sender: AnyObject) {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        delay(0.25) {
            self.preventAnimation.removeAll()
            self.getPosts(self.latestPosts, params: self.parametersTech)
        }
        delay(0.75){
            self.tableView.hidden = false
        }
        navBarTitle.title = "tech"
        sortTechIcon.tintColor = UIColor.whiteColor()
        homeButtonIcon.tintColor = inactiveColor
        sortTutorialsIcon.tintColor = inactiveColor
        sortGamesIcon.tintColor = inactiveColor
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
    
    func getPosts(getposts : String, params: AnyObject) {
        
          Alamofire.request(.GET, getposts, parameters: params as? [String : AnyObject]).responseJSON { response in
                
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