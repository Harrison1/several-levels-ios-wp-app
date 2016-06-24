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
    let parameters: [String:AnyObject] = ["filter[posts_per_page]" : 100]
    var json : JSON = JSON.null

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPosts(latestPosts)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LatestPostsTableViewController.newNews), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func newNews()
    {
        getPosts(latestPosts)
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
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
        
        //Make sure post title is a string
        if let title = self.json[row]["title"]["rendered"].string {
            cell.postTitle!.text = title
        }
        
        //Make sure post date is a string
        if let date = self.json[row]["date"].string {
            cell.postDate!.text = date
        }
        
        if let featureImage = self.json[row]["featured_image_url"].string {
            let image : NSURL? = NSURL(string: featureImage)
            cell.postImage.sd_setImageWithURL(image)
        }

//        if let image = self.json[row]["featured_image_url"].string{
//            
//            if image != "null"{
//                            
//                ImageLoader.sharedLoader.imageForUrl(image, completionHandler:{(image: UIImage?, url: String) in
//                    cell.postImage.image = image!
//                })
//            }
//        }
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let singlePostVC : SinglePostViewController = storyboard!.instantiateViewControllerWithIdentifier("SinglePostViewController") as! SinglePostViewController
//        singlePostVC.json = self.json[indexPath.row]
//        self.navigationController?.pushViewController(singlePostVC, animated: true)
//        
//    }

//    func populateFields(cell: LatestPostsTableViewCell, index: Int){
//        
//        //Make sure post title is a string
//        guard let title = self.json[index]["title"]["rendered"].string else{
//            cell.postTitle!.text = "Title Loading..."
//            return
//        }
//        
//        // An action must always proceed the guard conditional
//        cell.postTitle!.text = title
//        
//        print("hello harrry")
//        
//        //Make sure post date is a string
//        guard let date = self.json[index]["date"].string else{
//            cell.postDate!.text = "Date --"
//            return
//        }
//        
//        cell.postDate!.text = date
//        print(date)
//        
//        /*
//         * Set up Featured Image
//         * Using guard, there's no need for nested if statements
//         * to unwrap and check optionals
//         */
//        
//        guard let image = self.json[index]["featured_image_url"].string where
//            image != "null"
//            else{
//                
//                print("Image didn't load")
//                return
//        }
//        
//        ImageLoader.sharedLoader.imageForUrl(image, completionHandler:{(image: UIImage?, url: String) in
//            cell.postImage.image = image!
//        })
//        
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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

class ImageLoader {
    
    var cache = NSCache()
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            let data: NSData? = self.cache.objectForKey(urlString) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            
            
            let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void in
                if (error != nil) {
                    completionHandler(image: nil, url: urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    self.cache.setObject(data!, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
                
            })
            downloadTask.resume()
        })
        
    }
}
