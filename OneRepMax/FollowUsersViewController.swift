//
//  FollowUsersViewController.swift
//  OneRepMax
//
//  Created by Jake on 7/18/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit
import AddressBook

class FollowUsersViewController: UITabBarController {
    
    var following : NSMutableArray = []
    
    var navItem = UINavigationItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.getFollowing()
        self.navBarSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.getFollowing()
    }
    
    func navBarSettings() {
        var backBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("back"))
        backBarButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationItem.leftBarButtonItem = backBarButton
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func getFollowing() {
        
        var followingRelation = PFUser.currentUser().objectForKey("following") as PFRelation!
        
        if followingRelation != nil {
            var query = followingRelation.query()
            
//            query.findObjectsInBackgroundWithBlock {
//                (objects: [AnyObject]!, error: NSError!) -> Void in
//                if (error == nil) {
//                    self.following = NSMutableArray(array: objects)
//                } else {
//                    // Log details of the failure
//                    NSLog("Error: %@ %@", error, error.userInfo!)
//                }
//            }
            self.following = NSMutableArray(array: query.findObjects())
        }
    }
}
