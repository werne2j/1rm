//
//  FollowersViewController.swift
//  OneRepMax
//
//  Created by Jake on 8/16/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var followers : NSArray = []
    var following : NSArray = []
    
    var tvc = UITableViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addNavBar()
        
        self.getFollowers()
        
        self.tvc.tableView = self.tableView
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.getFollowers()
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
        
        navItem.title = "Followers"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)]
        navbar.titleTextAttributes = titleDict
        
        navbar.items = [navItem]
        self.view.addSubview(navbar)
    }
    
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getFollowers() {
        var query = PFUser.query()
        query.whereKey("following", equalTo: PFUser.currentUser())

        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                self.followers = objects
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    /* ----------------- table view stuff --------------------------- */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followers.count
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : FollowingTableViewCell = tableView.dequeueReusableCellWithIdentifier("FollowerCell", forIndexPath: indexPath) as FollowingTableViewCell
        
        let user = self.followers.objectAtIndex(indexPath.row) as PFUser
        
        cell.nameLabel.text = user["username"] as? String
        
        cell.userImage.image = UIImage(named: "icn_noimage")
        
        if (user.objectForKey("avatar") != nil) {
            cell.userImage.file = user.objectForKey("avatar") as PFFile
            cell.userImage.loadInBackground()
        }
        
        let checked = UIImage(named: "check")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let plus = UIImage(named: "plus")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        if self.isFollowing(user) {
            cell.followButton.setImage(checked, forState: UIControlState.Normal)
        } else {
            cell.followButton.setImage(plus, forState: UIControlState.Normal)
        }
        
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.cornerRadius = 20
        
        cell.followButton.tintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        cell.followButton.tag = indexPath.row
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }
    
    @IBAction func followUsers(sender: UIButton) {
        
        var indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as FollowingTableViewCell
        
        let current = PFUser.currentUser()
        
        let user = self.followers.objectAtIndex(indexPath.row) as PFUser
        
        let checked = UIImage(named: "check")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let plus = UIImage(named: "plus")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        if self.isFollowing(user) {
            
            // unfollow user
            cell.followButton.setImage(plus, forState: UIControlState.Normal)
            
            let relation = current.relationForKey("following")
            relation.removeObject(user)
            current.saveInBackground()
            
        } else {
            
            cell.followButton.setImage(checked, forState: UIControlState.Normal)
            
            let relation = current.relationForKey("following")
            relation.addObject(user)
            current.saveInBackground()
            
        }
        
    }
    
    func isFollowing(user: PFUser) -> Bool {
        
        for f in following {
            if f.objectId == user.objectId {
                return true
            }
        }
        
        return false
    }

}
