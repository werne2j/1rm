//
//  ContactsTableViewController.swift
//  OneRepMax
//
//  Created by Jake on 7/29/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit
import AddressBook

class ContactsTableViewController: UITableViewController {

    var addressBook: ABAddressBookRef?
    
    var numberArray : NSMutableArray = []
    
    var users : NSArray = []
    var following : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.getUsers()
        
        // Address book authorization ------------------------------------------------------------
        
        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.NotDetermined) {
            var errorRef: Unmanaged<CFError>? = nil
            addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    self.getContactNames()
                }
                else {
                    println("error")
                }
                })
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Restricted) {
            println("access denied")
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Authorized) {
            self.getContactNames()
        }
        
        // ----------------------------------------------------------------------------------------

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.title = "Contacts"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 0
        
        for u in self.users {
            if numberArray.containsObject(u["phone"]!!) {
                count = count + 1
            }
        }
        return count
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : ContactTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as ContactTableViewCell
        
        let user = self.users.objectAtIndex(indexPath.row) as PFUser
        
        if numberArray.containsObject(user["phone"]) {

            cell.nameLabel.text = user["username"] as? String
            
            cell.userImage.image = UIImage(named: "icn_noimage")
            
            if (user.objectForKey("avatar") != nil) {
                cell.userImage.file = user.objectForKey("avatar") as PFFile
                cell.userImage.loadInBackground()
            }
            
            cell.userImage.layer.masksToBounds = true
            cell.userImage.layer.cornerRadius = 25
            
            if self.isFollowing(user) {
                cell.followButton.setTitle("Unfollow", forState: UIControlState.Normal)
            } else {
                cell.followButton.setTitle("Follow", forState: UIControlState.Normal)
            }
            
            cell.followButton.tag = indexPath.row
        }
        
        return cell
        
    }
    
    
    // Address book methods -----------------------------------------------------------------------------
    
    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    func getContactNames() {
        var errorRef: Unmanaged<CFError>?
        addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        var contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        
        for record:ABRecordRef in contactList {
            var contactPerson: ABRecordRef = record
            
            let unmanagedPhones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty)
            let phones: ABMultiValueRef =
            Unmanaged.fromOpaque(unmanagedPhones.toOpaque()).takeUnretainedValue()
                as NSObject as ABMultiValueRef
            
            let countOfPhones = ABMultiValueGetCount(phones)
            
            for index in 0..<countOfPhones{
                let unmanagedPhone = ABMultiValueCopyValueAtIndex(phones, index)
                var phone: String = Unmanaged.fromOpaque(
                    unmanagedPhone.toOpaque()).takeUnretainedValue() as NSObject as String
    
                phone = replaceCharacters(phone)
                self.numberArray.addObject(phone)
            }
        }
    }
    
    func replaceCharacters(phone: String) -> String {
        
        var phone = phone
        
        phone = phone.stringByReplacingOccurrencesOfString("(", withString: "", options: nil, range: nil)
        phone = phone.stringByReplacingOccurrencesOfString(")", withString: "", options: nil, range: nil)
        phone = phone.stringByReplacingOccurrencesOfString("-", withString: "", options: nil, range: nil)
        phone = phone.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        phone = phone.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        
        return phone
    }
    
    // ---------------------------------------------------------------------------------------------------

    
    func getUsers() {
        
        var query = PFUser.query()
        query.whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                self.users = objects
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
        
        let user = self.users.objectAtIndex(indexPath.row) as PFUser

        
        if self.isFollowing(user) {
            
            // unfollow user
            let relation = current.relationForKey("following")
            relation.removeObject(user)
            current.saveInBackground()
            
        } else {
            
            let relation = current.relationForKey("following")
            relation.addObject(user)
            current.saveInBackground()
            
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
    
}
