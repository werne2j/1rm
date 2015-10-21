//
//  SquatLeadersViewController.swift
//  OneRepMax
//
//  Created by Jake on 9/2/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class SquatLeadersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var squatLeaders : NSArray = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getSquatLeaders()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.addBorder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.getSquatLeaders()
    }
    
    func addBorder() {
        
        let mainViewSize = self.view.bounds.size
        let borderWidth = 0.3 as CGFloat
        let borderColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1).CGColor
        
        var leftView = UIView(frame: CGRectMake(0, 0, borderWidth, mainViewSize.height))
        var rightView = UIView(frame: CGRectMake(mainViewSize.width - borderWidth, 0, borderWidth, mainViewSize.height))
        
        leftView.opaque = true
        rightView.opaque = true
        leftView.layer.backgroundColor = borderColor
        rightView.layer.backgroundColor = borderColor
        
        leftView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin
        rightView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin
        self.view.addSubview(leftView)
        self.view.addSubview(rightView)
    }

    func getSquatLeaders() {
        
        var query = PFUser.query()
        query.whereKeyExists("squat")
        query.orderByDescending("squat")
        query.limit = 10
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                self.squatLeaders = objects
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
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
    
    @IBAction func followUsers(sender: UIButton) {
        
        var fvc = self.tabBarController as FollowUsersViewController
        
        var indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as BenchTableViewCell
        
        let current = PFUser.currentUser() as PFUser
        
        let user = self.squatLeaders.objectAtIndex(indexPath.row) as PFUser
        
        let checked = UIImage(named: "check")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let plus = UIImage(named: "plus")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        if self.isFollowing(user) {
            
            // unfollow user
            cell.followButton.setImage(plus, forState: UIControlState.Normal)
            
            let relation = current.relationForKey("following")
            relation.removeObject(user)
            current.saveInBackground()
            
        } else if user.objectId == current.objectId {
            
        } else {
            
            cell.followButton.setImage(checked, forState: UIControlState.Normal)
            
            let relation = current.relationForKey("following")
            relation.addObject(user)
            current.saveInBackground()
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.squatLeaders.count
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : BenchTableViewCell = tableView.dequeueReusableCellWithIdentifier("SquatCell", forIndexPath: indexPath) as BenchTableViewCell
        
        let user = self.squatLeaders.objectAtIndex(indexPath.row) as PFUser
        
        cell.username.text = user["username"] as? String
        
        cell.weight.text = String(user.objectForKey("squat") as Int)
        
        cell.userImage.image = UIImage(named: "icn_noimage")
        
        if (user.objectForKey("avatar") != nil) {
            cell.userImage.file = user.objectForKey("avatar") as PFFile
            cell.userImage.loadInBackground()
        }
        
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.cornerRadius = 20
        
        
        let checked = UIImage(named: "check")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let plus = UIImage(named: "plus")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let me = UIImage(named: "user")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        if user.objectId == PFUser.currentUser().objectId {
            cell.followButton.setImage(me, forState: UIControlState.Normal)
        } else if self.isFollowing(user) {
            cell.followButton.setImage(checked, forState: UIControlState.Normal)
        } else {
            cell.followButton.setImage(plus, forState: UIControlState.Normal)
        }
        
        cell.placeLabel.text = String(Int(indexPath.row) + 1)
        cell.followButton.tintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        cell.followButton.tag = indexPath.row
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
}
