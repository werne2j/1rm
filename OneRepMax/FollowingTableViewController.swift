//
//  FollowingTableViewController.swift
//  OneRepMax
//
//  Created by Jake on 7/29/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class FollowingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var following : NSArray = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var tvc = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBar()
        
        self.getFollowing()
        
        self.tvc.tableView = self.tableView
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.getFollowing() 
    }
    
    func getFollowing() {
        
        var followingRelation = PFUser.currentUser().objectForKey("following") as PFRelation!
        
        if followingRelation != nil {
            var query = followingRelation.query()
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if (error == nil) {
                    self.following = objects
                    self.tableView.reloadData()
                    
                } else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error, error.userInfo!)
                }
            }
        }
    }
    
    @IBAction func unfollow(sender: UIButton) {
        
        var indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as FollowingTableViewCell
   
        let current = PFUser.currentUser()

        let user = self.following.objectAtIndex(indexPath.row) as PFUser
        
        let plus = UIImage(named: "plus")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)

        cell.unfollowButton.setImage(plus, forState: UIControlState.Normal)

        let relation = current.relationForKey("following")
        relation.removeObject(user)
        current.saveInBackground()
        
    }
    
    func addNavBar() {
        
        var inset = UIEdgeInsetsMake(65, 0, 0, 0)
        self.tableView.contentInset = inset
        
        var navbar = UINavigationBar(frame: CGRectMake(0, 0, 320, 64))
        var navItem = UINavigationItem()
        
        var backBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("back"))
        backBarButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        
        navbar.translucent = false
        navItem.leftBarButtonItem = backBarButton
        navbar.barTintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        
        navItem.title = "Following"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)]
        navbar.titleTextAttributes = titleDict
        
        navbar.items = [navItem]
        self.view.addSubview(navbar)
    }


    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* ----------------- table view stuff --------------------------- */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.following.count
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : FollowingTableViewCell = tableView.dequeueReusableCellWithIdentifier("FollowingCell", forIndexPath: indexPath) as FollowingTableViewCell
        
        let user = self.following.objectAtIndex(indexPath.row) as PFUser
        
        
        cell.nameLabel.text = user["username"] as? String
        
        cell.userImage.image = UIImage(named: "icn_noimage")
        
        if (user.objectForKey("avatar") != nil) {
            cell.userImage.file = user.objectForKey("avatar") as PFFile
            cell.userImage.loadInBackground()
        }
        
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.cornerRadius = 20
        
        cell.unfollowButton.tag = indexPath.row
        cell.unfollowButton.tintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
}
