//
//  LatestPostsViewController.swift
//  several levels
//
//  Created by Harrison McGuire on 6/14/16.
//  Copyright © 2016 severallevels. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class LatestPostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var sectionTitle: UILabel!
    
//    let extensionView = sectionTitle
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let latestPosts : String = "http://severallevels.io/wp-json/wp/v2/posts/"
    let parameters: [String:AnyObject] = ["filter[posts_per_page]" : 100]
    
    let parametersNu : [String:AnyObject] = [
        "filter[category_name]" : "tutorials",
        "filter[posts_per_page]" : 5
    ]
    
    var json : JSON = JSON.null
    lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBgView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        statusBgView.backgroundColor = UIColor(red: 39/255, green: 207/255, blue: 230/255, alpha: 1)
        self.view.addSubview(statusBgView)
        
        getPosts(latestPosts)
                
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.tintColor = UIColor(red: 39/255, green: 207/255, blue: 230/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(LatestPostsViewController.newNews), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        navigationController?.hidesBarsOnSwipe = true
//    }
    
    func newNews() {
        getPosts(latestPosts)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        sectionTitle.text = "the latest"
    }
    
    
    func navTutorials() {
        getPostsNu(latestPosts)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        sectionTitle.text = "tutorials"
    }
    
    @IBAction func segmentedNavigation(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            newNews()
        case 1:
            navTutorials()
        case 2:
            print("hello games")
        case 3:
            print("hello tech")
        default:
            break
        }
    }
//    if let tabBar = navigationController?.too {
//        hidingNavBarManager?.manageBottomBar(too)
//    }
    
    
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
    
    func getPostsNu(getposts : String) {
        
        Alamofire.request(.GET, getposts, parameters: parametersNu).responseJSON { response in
            
            guard let data = response.result.value else{
                print("Request failed with error")
                return
            }
            
            self.tableView.setContentOffset(CGPointZero, animated: false)
            
            self.json = JSON(data)
            self.tableView.reloadData()
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.json.type {
            case Type.Array:
                return self.json.count
            default:
                return 1
            }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! LatestPostsCell
        
        // Get row index
        let row = indexPath.row
        
        //Make sure post title is a string
        if let title = self.json[row]["title"]["rendered"].string {
            cell.postT.text = title
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
            
            cell.postD.text = dateStringConverted
            
        }
        
        if let featureImage = self.json[row]["featured_image_url"].string {
            let image : NSURL? = NSURL(string: featureImage)
            cell.postI.sd_setImageWithURL(image)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260.0
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//        selectedCell.selectionStyle = .None
//    }
    
//    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//        selectedCell.selectionStyle = .None
//    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.contentView.backgroundColor = UIColor.blackColor()
        
        let blackSpaceView : UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 240))
        
        blackSpaceView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [44/255, 44/255, 44/255, 1.0])
        
        cell.contentView.addSubview(blackSpaceView)
        cell.contentView.sendSubviewToBack(blackSpaceView)
        
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
    
    // MARK: - HidingNavigationBarManagerDelegate
    
    func hidingNavigationBarManagerDidChangeState(manager: HidingNavigationBarManager, toState state: HidingNavigationBarState) {
        
    }
    
    func hidingNavigationBarManagerDidUpdateScrollViewInsets(manager: HidingNavigationBarManager) {
        
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
