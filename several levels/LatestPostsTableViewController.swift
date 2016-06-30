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
    

    @IBOutlet var navBarTitle: UINavigationItem!
    

    let latestPosts : String = "https://severallevels.io/wp-json/wp/v2/posts/"
    let parameters: [String:AnyObject] = ["filter[posts_per_page]" : 100]
    let parametersTutorials : [String:AnyObject] = ["filter[category_name]" : "tutorials","filter[posts_per_page]" : 100]
    let parametersGames : [String:AnyObject] = ["filter[category_name]" : "games", "filter[posts_per_page]" : 100]
    let parametersTech : [String:AnyObject] = ["filter[category_name]" : "tech", "filter[posts_per_page]" : 100]
    
    let imagePlaceHolder : UIImage = UIImage(named: "placeholder")!

    var json : JSON = JSON.null
    var preventAnimation = Set<NSIndexPath>()
    
    // loading view
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    let loadingImage = UIImageView()
    let loadingName = UILabel()
    let loadingMotto = UILabel()
    
    let customControl = UISegmentedControl(items: [UIImage(named: "home")!, UIImage(named: "tutorials")!, UIImage(named: "games")!, UIImage(named: "tech")!])
    
    override func loadView() {
        super.loadView()
        
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)

        customControl.selectedSegmentIndex = 0
        
        let frame = UIScreen.mainScreen().bounds
        customControl.frame = CGRectMake(0, 0, frame.width - 20, 34)
        
        customControl.tintColor = UIColor.whiteColor()
        
        customControl.addTarget(self, action: #selector(LatestPostsTableViewController.filterSelect), forControlEvents: .ValueChanged)
        
        customControl.setDividerImage(self.imageWithColor(UIColor.clearColor()), forLeftSegmentState: UIControlState.Normal, rightSegmentState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        
        customControl.setBackgroundImage(self.imageWithColor(UIColor.clearColor()), forState:UIControlState.Normal, barMetrics:UIBarMetrics.Default)
        
        customControl.setBackgroundImage(self.imageWithColor(UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha:1.0)), forState:UIControlState.Selected, barMetrics:UIBarMetrics.Default);
        
        let segmentedControl = UIBarButtonItem(customView: customControl)
        
        let toolbarArray = [flexibleSpace, segmentedControl, flexibleSpace]
        
        self.setToolbarItems(toolbarArray, animated: true)
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 39/255, green: 207/255, blue: 230/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(LatestPostsTableViewController.filterSelect), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterSelect()
        
    }
    
    func imageWithColor(color: UIColor) -> UIImage {
    
        let rect = CGRectMake(0.0, 0.0, 1.0, customControl.frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func filterSelect() {
        switch customControl.selectedSegmentIndex {
            case 0:
                filterAll()
            case 1:
                filterTutorials()
            case 2:
                filterGames()
            case 3:
                filterTech()
            default:
                filterAll()
        }
    }
    
    func filterAll() {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        self.setLoadingScreen()
        self.preventAnimation.removeAll()
        self.getPosts(self.latestPosts, params: self.parameters)
        self.tableView.reloadData()
        navBarTitle.title = "The Latest"
        self.refreshControl?.endRefreshing()
        tableView.hidden = false
        
        delay(1) {
            self.removeLoadingScreen()
        }
    }

    func filterTutorials() {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        self.setLoadingScreen()
        self.preventAnimation.removeAll()
        self.getPosts(self.latestPosts, params: self.parametersTutorials)
        self.tableView.reloadData()
        self.navBarTitle.title = "Tutorials"
        self.refreshControl?.endRefreshing()
        tableView.hidden = false
        
        delay(1) {
            self.removeLoadingScreen()
        }
    }
    
    func filterGames() {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        self.setLoadingScreen()
        self.preventAnimation.removeAll()
        self.getPosts(self.latestPosts, params: self.parametersGames)
        navBarTitle.title = "Games"
        self.refreshControl?.endRefreshing()
        self.tableView.hidden = false

        delay(1) {
            self.removeLoadingScreen()
        }
        
    }
    
    
    func filterTech() {
        tableView.hidden = true
        self.tableView.setContentOffset(CGPointZero, animated:false)
        self.setLoadingScreen()
        self.preventAnimation.removeAll()
        self.getPosts(self.latestPosts, params: self.parametersTech)
        self.tableView.hidden = false
        navBarTitle.title = "Tech"
        self.refreshControl?.endRefreshing()
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
        
        if let featureImage = self.json[row]["featured_image_url"].string {
            let image : NSURL? = NSURL(string: featureImage)
            cell.postImage.sd_setImageWithURL(image, placeholderImage: imagePlaceHolder)
        }
        
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
            
            cell.postDate!.text = "posted on \(dateStringConverted)"
        }
        
        if let content = self.json[row]["content"]["rendered"].string {
            cell.postPreview.text = content
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
        self.loadingImage.hidden = false
        self.loadingName.hidden = false
        self.loadingMotto.hidden = false
        loadingView.layer.opacity = 1
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = tableView.frame.size.width
        let height: CGFloat = tableView.frame.size.height
        let x = (self.tableView.frame.width / 2)
        let y = (self.tableView.frame.height / 2) - (self.navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRectMake(0, 0, width, height)
        loadingView.backgroundColor = UIColor.blackColor()
        
        // Sets loading image
        self.loadingImage.frame = CGRectMake(30, 30, 100, 100)
        self.loadingImage.image = UIImage(named: "home")
        
        // Sets loading text
        self.loadingName.textColor = UIColor.whiteColor()
        self.loadingName.textAlignment = NSTextAlignment.Center
        self.loadingName.text = "several levels"
        self.loadingName.font = UIFont.systemFontOfSize(30.0)
        self.loadingName.frame = CGRectMake(0, 50, self.tableView.frame.width - 20, 50)
        
        // Sets loading text
        self.loadingMotto.textColor = UIColor.whiteColor()
        self.loadingMotto.textAlignment = NSTextAlignment.Center
        self.loadingMotto.text = "we make and talk about software"
        self.loadingMotto.frame = CGRectMake(0, 80, self.tableView.frame.width - 20, 50)
        
        
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
        loadingView.addSubview(self.loadingName)
        loadingView.addSubview(self.loadingMotto)
        
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
            self.loadingImage.hidden = true
            self.loadingLabel.hidden = true
            self.loadingView.hidden = true
        }
        
    }
}