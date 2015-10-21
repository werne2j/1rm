//
//  TopUsersViewController.swift
//  OneRepMax
//
//  Created by Jake on 8/19/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class TopUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tvc = UITableViewController()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var inset = UIEdgeInsetsMake(65, 0, 0, 0)
        self.tableView.contentInset = inset
        
        // Do any additional setup after loading the view.
//        self.getNotFollowing()
    }
    
    func getNotFollowing() {
        
        var followingRelation = PFUser.currentUser().objectForKey("following") as PFRelation!
        var following = followingRelation.query()
        
        var query = PFUser.query()
        query.whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
        query.whereKey("objectId", doesNotMatchKey: "objectId", inQuery: following)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                print(objects)
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }


    
    /* ----------------- table view stuff --------------------------- */
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, willSelectRowAtIndexPath indexPath: NSIndexPath!) -> NSIndexPath! {
        return nil
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell : ContactTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as ContactTableViewCell
//
//        let user = self.followers.objectAtIndex(indexPath.row) as PFUser
//        
//        cell.nameLabel.text = user["username"] as String
//        
//        cell.userImage.image = UIImage(named: "icn_noimage")
//        
//        if user.objectForKey("avatar") {
//            cell.userImage.file = user.objectForKey("avatar") as PFFile
//            cell.userImage.loadInBackground()
//        }
//        
//        cell.userImage.layer.masksToBounds = true
//        cell.userImage.layer.cornerRadius = 25
        
        return cell
    }
}
