//
//  SearchTableViewController.swift
//  OneRepMax
//
//  Created by Jake on 9/10/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class SearchTableViewController: PFQueryTableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults : NSMutableArray = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "_User"
        self.paginationEnabled = false
        self.pullToRefreshEnabled = false
        self.objectsPerPage = 10
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.searchDisplayController?.searchResultsTableView.tableFooterView = UIView(frame: CGRectZero)
        self.searchDisplayController?.searchResultsTableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.title = "Search"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.searchBar.becomeFirstResponder()
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

    func filterResults(searchTerm : NSString) {
        self.searchResults.removeAllObjects()
        
        var user : PFUser
        var name : NSString = ""
        
        for user in self.objects {
            var username : NSString = user.username as NSString
            if user.objectForKey("name") != nil {
                name = user.objectForKey("name") as NSString
            }
            if username.lowercaseString.hasPrefix(searchTerm.lowercaseString) || name.lowercaseString.hasPrefix(searchTerm.lowercaseString) {
                self.searchResults.addObject(user)
            }
        }
    }
    
    @IBAction func followUsers(sender: UIButton) {
        
        var indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        var cell = self.searchDisplayController?.searchResultsTableView.cellForRowAtIndexPath(indexPath) as SearchViewCell
        
        let current = PFUser.currentUser() as PFUser
        
        let user = self.searchResults.objectAtIndex(indexPath.row) as PFUser
        
        let checked = UIImage(named: "check")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let plus = UIImage(named: "plus")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        if self.isFollowing(user) {
            
            // unfollow user
            cell.followingButton.setImage(plus, forState: UIControlState.Normal)
            
            let relation = current.relationForKey("following")
            relation.removeObject(user)
            current.saveInBackground()
            
        } else if user.objectId == current.objectId {
            
        } else {
            
            cell.followingButton.setImage(checked, forState: UIControlState.Normal)
            
            let relation = current.relationForKey("following")
            relation.addObject(user)
            current.saveInBackground()
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterResults(searchString)
        return true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        
        let cell : SearchViewCell = self.tableView.dequeueReusableCellWithIdentifier("PFSearchCell") as SearchViewCell
        
        var user = self.searchResults[indexPath.row] as PFUser
        
        cell.userImage.image = UIImage(named: "icn_noimage")
        
        if (user.objectForKey("avatar") != nil) {
            cell.userImage.file = user.objectForKey("avatar") as PFFile
            cell.userImage.loadInBackground()
        }
        
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.cornerRadius = 20
        
        cell.username.text = user.username
        
        let checked = UIImage(named: "check")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let plus = UIImage(named: "plus")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let me = UIImage(named: "user")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        if user.objectId == PFUser.currentUser().objectId {
            cell.followingButton.setImage(me, forState: UIControlState.Normal)
        } else if self.isFollowing(user) {
            cell.followingButton.setImage(checked, forState: UIControlState.Normal)
        } else {
            cell.followingButton.setImage(plus, forState: UIControlState.Normal)
        }
        
        cell.followingButton.tintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        cell.followingButton.tag = indexPath.row
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }

}
