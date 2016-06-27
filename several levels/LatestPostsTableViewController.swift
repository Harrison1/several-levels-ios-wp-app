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
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 39/255, green: 207/255, blue: 230/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(LatestPostsTableViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
//        self.setLoadingScreen()
        
        loadData()
        
    }
    
    func loadData() {
        self.tableView.setContentOffset(CGPointZero, animated:false)
        self.preventAnimation.removeAll()
        self.getPosts(self.latestPosts, params: self.parameters)
        self.tableView.reloadData()
        navBarTitle.title = "several levels"
        homeButtonIcon.tintColor = UIColor.whiteColor()
        sortTutorialsIcon.tintColor = inactiveColor
        sortGamesIcon.tintColor = inactiveColor
        sortTechIcon.tintColor = inactiveColor
        self.refreshControl?.endRefreshing()
    }
    
    @IBAction func homeButton(sender: AnyObject) {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        self.setLoadingScreen()
        self.preventAnimation.removeAll()
        self.getPosts(self.latestPosts, params: self.parameters)
        self.tableView.reloadData()
        navBarTitle.title = "The Latest"
        homeButtonIcon.tintColor = UIColor.whiteColor()
        sortTutorialsIcon.tintColor = inactiveColor
        sortGamesIcon.tintColor = inactiveColor
        sortTechIcon.tintColor = inactiveColor
        tableView.hidden = false
        
        delay(1) {
            self.removeLoadingScreen()
        }
    }
    
    @IBAction func sortTutorials(sender: UIBarButtonItem) {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        self.setLoadingScreen()
        self.preventAnimation.removeAll()
        self.getPosts(self.latestPosts, params: self.parametersTutorials)
        self.tableView.reloadData()
        self.navBarTitle.title = "Tutorials"
        self.sortTutorialsIcon.tintColor = UIColor.whiteColor()
        self.homeButtonIcon.tintColor = self.inactiveColor
        self.sortGamesIcon.tintColor = self.inactiveColor
        self.sortTechIcon.tintColor = self.inactiveColor
        tableView.hidden = false
        
        delay(1) {
            self.removeLoadingScreen()
        }
    }
    
    @IBAction func sortGames(sender: AnyObject) {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        self.setLoadingScreen()
        self.preventAnimation.removeAll()
        self.getPosts(self.latestPosts, params: self.parametersGames)
        navBarTitle.title = "Games"
        sortGamesIcon.tintColor = UIColor.whiteColor()
        homeButtonIcon.tintColor = inactiveColor
        sortTutorialsIcon.tintColor = inactiveColor
        sortTechIcon.tintColor = inactiveColor
        self.tableView.hidden = false

        delay(1) {
            self.removeLoadingScreen()
        }
        
    }
    
    
    @IBAction func sortTech(sender: AnyObject) {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        self.setLoadingScreen()
        self.preventAnimation.removeAll()
        self.getPosts(self.latestPosts, params: self.parametersTech)
        self.tableView.hidden = false
        navBarTitle.title = "Tech"
        sortTechIcon.tintColor = UIColor.whiteColor()
        homeButtonIcon.tintColor = inactiveColor
        sortTutorialsIcon.tintColor = inactiveColor
        sortGamesIcon.tintColor = inactiveColor
        self.tableView.hidden = false

        delay(1) {
            self.removeLoadingScreen()
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
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        self.loadingLabel.hidden = false
        self.loadingView.hidden = false
        loadingView.layer.opacity = 1
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = tableView.frame.size.width
        let height: CGFloat = tableView.frame.size.height
        let x = (self.tableView.frame.width / 2)
        let y = (self.tableView.frame.height / 2) - (self.navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRectMake(0, 0, width, height)
        loadingView.backgroundColor = UIColor.blackColor()
        
        // Sets loading text
        self.loadingLabel.textColor = UIColor.whiteColor()
        self.loadingLabel.textAlignment = NSTextAlignment.Center
        self.loadingLabel.text = "Loading..."
        self.loadingLabel.frame = CGRectMake(x-30, y, 140, 30)
        
        // Sets spinner
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        self.spinner.frame = CGRectMake(x-30, y, 30, 30)
        self.spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(self.spinner)
        loadingView.addSubview(self.loadingLabel)
        
        self.tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        UIView.animateWithDuration(1) {
            self.loadingView.layer.opacity = 0
        }
        
        // Hides and stops the text and the spinner
        delay(1) {
            self.spinner.stopAnimating()
            self.loadingLabel.hidden = true
            self.loadingView.hidden = true
        }
        
    }

}