//
//  UsersCloseTableViewController.swift
//  OneRepMax
//
//  Created by Jake on 7/31/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class UsersCloseTableViewController: UITableViewController {
    
    var usersNear : NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    
        self.getUsersNearBy()
    
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.getUsersNearBy()
        self.tabBarController?.navigationItem.title = "Users Close"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersNear.count
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ContactTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as ContactTableViewCell

        let user = self.usersNear.objectAtIndex(indexPath.row) as PFUser
        
        if !self.isFollowing(user) {
            cell.nameLabel.text = user["username"] as? String
            
            cell.userImage.image = UIImage(named: "icn_noimage")
            
            if (user.objectForKey("avatar") != nil) {
                cell.userImage.file = user.objectForKey("avatar") as PFFile
                cell.userImage.loadInBackground()
            }
            
            cell.userImage.layer.masksToBounds = true
            cell.userImage.layer.cornerRadius = 20
            
            cell.followButton.tag = indexPath.row
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
    
        return cell
    }

    func getUsersNearBy() {
        
        var userLocation : PFGeoPoint = PFUser.currentUser()["currentLocation"] as PFGeoPoint
        var followingRelation = PFUser.currentUser().objectForKey("following") as PFRelation!
        
        var query = PFUser.query()
        query.whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
    
        if followingRelation != nil {
            var following = followingRelation.query()
            query.whereKey("objectId", doesNotMatchKey: "objectId", inQuery: following)
        }

        query.whereKey("currentLocation", nearGeoPoint: userLocation, withinMiles: 50)
        query.limit = 10
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                self.usersNear = objects
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
 
    }
    
    @IBAction func followUser(sender: AnyObject) {
        
        var indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as ContactTableViewCell
        
        let current = PFUser.currentUser()
        
        let user = self.usersNear.objectAtIndex(indexPath.row) as PFUser

        let relation = current.relationForKey("following")
        
        let checked = UIImage(named: "check")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.followButton.setImage(checked, forState: UIControlState.Normal)
        cell.followButton.tintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)

        relation.addObject(user)
        current.saveInBackground()

    }
    
    func isFollowing(user: PFUser) -> Bool {
        
        var fvc = self.tabBarController as FollowUsersViewController
        
        for f in fvc.following {
            if f.objectId == user.objectId {
                return true
            }
        }
        
        return false
    }
}
