//
//  FeedViewController.swift
//  OneRepMax
//
//  Created by Jake on 7/7/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    weak var delegate: ChildVCDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var following : NSArray = []
    
    var posts : NSArray = []
    
    var tvc = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.addNavBar()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tvc.tableView = self.tableView
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        var refresh = UIRefreshControl()
        refresh.addTarget(self, action: Selector("getPosts"), forControlEvents: UIControlEvents.ValueChanged)
        self.tvc.refreshControl = refresh

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.getPosts()
        
        if self.posts.count == 0 {
            self.tableView.hidden = true
        } else {
            self.tableView.hidden = false
        }
    }

    func informDelegateToScrollMethod(sender: AnyObject) {
        self.delegate?.childVC(self, scrollButton:sender as UIBarButtonItem)
    }
    
    func followUsersSegue() {
        self.performSegueWithIdentifier("followUsers", sender: self)
    }
    
    func addNavBar() {
        
        var inset = UIEdgeInsetsMake(65, 0, 0, 0)
        self.tableView.contentInset = inset
        
        var navbar = UINavigationBar(frame: CGRectMake(0, 0, 320, 64))
        var navItem = UINavigationItem()
        
        var mainBarButton = UIBarButtonItem(image: UIImage(named: "Icon-5"), style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("informDelegateToScrollMethod:"))
        var followBarButton = UIBarButtonItem(image: UIImage(named: "add_user"), style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("followUsersSegue"))
        
        
        followBarButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        mainBarButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        
        navbar.translucent = false
        navItem.rightBarButtonItem = mainBarButton
        navItem.leftBarButtonItem = followBarButton
        navItem.title = "Feed"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)]
        navbar.titleTextAttributes = titleDict
        
        navbar.barTintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        
        navbar.items = [navItem]
        self.view.addSubview(navbar)
    }
    
    func getPosts() {
        
        var followingRelation = PFUser.currentUser().objectForKey("following") as PFRelation!
        
        if followingRelation != nil {
            var following = followingRelation.query()
            
            var query = PFQuery(className: "Post")
            query.includeKey("user")
            query.whereKey("user", matchesQuery: following)
            query.orderByDescending("createdAt")
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if (error == nil) {
                    self.posts = objects
                    self.tableView.reloadData()
                    
                } else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error, error.userInfo!)
                }
            }

        }
        
        if (self.tvc.refreshControl != nil) {
            if (self.tvc.refreshControl?.refreshing != nil) {
               self.tvc.refreshControl?.endRefreshing()
            }
        }
    }
    
    // #pragma mark - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as PostTableViewCell
        
        var post : PFObject = self.posts.objectAtIndex(indexPath.row) as PFObject
        
        let user: AnyObject! = post.objectForKey("user")
        let username = user.objectForKey("username") as String
        
        let lift = post.objectForKey("lift") as String
        let weight = post.objectForKey("weight") as Int
        
        cell.thumbnail.image = UIImage(named: "icn_noimage")
        
        if (user.objectForKey("avatar") != nil) {
            cell.thumbnail.file = user.objectForKey("avatar") as PFFile
            cell.thumbnail.loadInBackground()
        }

        if lift == "bench" {
            cell.liftImage.image = UIImage(named: "bench")
        } else if lift == "squat" {
            cell.liftImage.image = UIImage(named: "squat")
        } else {
            cell.liftImage.image = UIImage(named: "deadlift")
        }
        
        cell.thumbnail.layer.masksToBounds = true
        cell.thumbnail.layer.cornerRadius = 30
        
        cell.weightField.layer.masksToBounds = true
        cell.weightField.layer.cornerRadius = 30
        
        cell.postLabel.text = username

        cell.weightField.text = String(weight)
        
//        if weight >= 500 {
//            cell.weightField.backgroundColor = UIColor(red: 252/255, green: 194/255, blue: 0, alpha: 1)
//        } else if weight >= 300 && weight < 500 {
//            cell.weightField.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
//        } else if weight < 300 {
//            cell.weightField.backgroundColor = UIColor(red: 176/255, green: 139/255, blue: 24/255, alpha: 1)
//        }
        
        cell.createdLabel.text = post.createdAt.timeAgoSinceNow()  
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }

}
