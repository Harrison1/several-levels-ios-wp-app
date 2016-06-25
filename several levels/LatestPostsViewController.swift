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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var preventAnimationv = Set<NSIndexPath>()

    
    let latestPosts : String = "https://severallevels.io/wp-json/wp/v2/posts/"
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
    lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = true

        
//        segmentedControl.setTitleTextAttributes([NSFontAttributeName:UIFont(name:"Helvetica Neue", size:13.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()], forState:UIControlState.Normal)
//        
//        segmentedControl.setTitleTextAttributes([NSFontAttributeName:UIFont(name:"Helvetica Neue", size:13.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()], forState:UIControlState.Selected)
//        
//        segmentedControl.setDividerImage(self.imageWithColor(UIColor.clearColor()), forLeftSegmentState: UIControlState.Normal, rightSegmentState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
//        
//        segmentedControl.setBackgroundImage(self.imageWithColor(UIColor.clearColor()), forState:UIControlState.Normal, barMetrics:UIBarMetrics.Default)
//        
//        segmentedControl.setBackgroundImage(self.imageWithColor(UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha:1.0)), forState:UIControlState.Selected, barMetrics:UIBarMetrics.Default);
//        
//        for  borderview in segmentedControl.subviews {
//            
//            let upperBorder: CALayer = CALayer()
//            upperBorder.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).CGColor
//            upperBorder.frame = CGRectMake(0, borderview.frame.size.height-1, borderview.frame.size.width, 1.0);
//            borderview.layer .addSublayer(upperBorder);
//            
//        }

        
        
        
        let statusBgView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        statusBgView.backgroundColor = UIColor(red: 39/255, green: 207/255, blue: 230/255, alpha: 1)
        self.view.addSubview(statusBgView)
        
        getPosts(latestPosts, params: parameters)
                
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.tintColor = UIColor(red: 39/255, green: 207/255, blue: 230/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(LatestPostsViewController.refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
//    func imageWithColor(color: UIColor) -> UIImage {
//        
//        let rect = CGRectMake(0.0, 0.0, 1.0, segmentedControl.frame.size.height)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//        CGContextSetFillColorWithColor(context, color.CGColor);
//        CGContextFillRect(context, rect);
//        let image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return image
//        
//    }
    
    func navLatest() {
        getPosts(latestPosts, params: parameters)
        tableView.setContentOffset(CGPointZero, animated:false)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        sectionTitle.text = "the latest"
    }
    
    
    func navTutorials() {
        getPosts(latestPosts, params: parametersTutorials)
        tableView.setContentOffset(CGPointZero, animated:false)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        sectionTitle.text = "tutorials"
    }
    
    func navGames() {
        getPosts(latestPosts, params: parametersGames)
        tableView.setContentOffset(CGPointZero, animated:false)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        sectionTitle.text = "games"
    }
    
    func navTech() {
        getPosts(latestPosts, params: parametersTech)
        tableView.setContentOffset(CGPointZero, animated:false)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        sectionTitle.text = "tech"
    }
    
    func refreshTable() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            navLatest()
        case 1:
            navTutorials()
        case 2:
            navGames()
        case 3:
            navTech()
        default:
            break
        }
        
    }
    
    @IBAction func segmentedNavigation(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            navLatest()
        case 1:
            navTutorials()
        case 2:
            navGames()
        case 3:
            navTech()
        default:
            break
        }
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
        
        if let category = self.json[row]["post_category"][0]["name"].string {
            cell.postC.text = "   " + category
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
        
                if !preventAnimationv.contains(indexPath) {
                    preventAnimationv.insert(indexPath)
                    TipInCellAnimator.animate(cell)
                }
        
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
    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        if !preventAnimation.contains(indexPath) {
//            preventAnimation.insert(indexPath)
//            TipInCellAnimator.animate(cell)
//        }
//    }
    
    // MARK: - HidingNavigationBarManagerDelegate
    
//    func hidingNavigationBarManagerDidChangeState(manager: HidingNavigationBarManager, toState state: HidingNavigationBarState) {
//        
//    }
//    
//    func hidingNavigationBarManagerDidUpdateScrollViewInsets(manager: HidingNavigationBarManager) {
//        
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
