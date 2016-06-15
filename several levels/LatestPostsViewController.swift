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
    let latestPosts : String = "http://severallevels.io/wp-json/wp/v2/posts/"
    let parameters: [String:AnyObject] = ["filter[posts_per_page]" : 100]
    var json : JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPosts(latestPosts)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //let refreshControl = UIRefreshControl()
        //refreshControl.addTarget(self, action: #selector(LatestPostsTableViewController.newNews), forControlEvents: UIControlEvents.ValueChanged)
        //self.refreshControl = refreshControl


        // Do any additional setup after loading the view.
    }
    
    func newNews()
    {
        getPosts(latestPosts)
        self.tableView.reloadData()
        //refreshControl?.endRefreshing()
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
            cell.postTitleH!.text = title
        }
        
        //Make sure post date is a string
        if let date = self.json[row]["date"].string {
            cell.postDateH!.text = date
        }
        
        if let featureImage = self.json[row]["featured_image_url"].string {
            let image : NSURL? = NSURL(string: featureImage)
            cell.postImageH.sd_setImageWithURL(image)
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
