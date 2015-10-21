//
//  SignupTableViewController.swift
//  OneRepMax
//
//  Created by Jake on 9/16/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class SignupTableViewController: UITableViewController, UITextFieldDelegate {
    
    var nextButton : UIBarButtonItem!

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var username : String!
    var email : String!
    var password : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.navBarSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false
        self.nextButton.enabled = false
        self.usernameField.becomeFirstResponder()

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject!) -> Bool {
        
        if identifier == "setupBio" {
            return false
        }
        
        return true
    }
    
    @IBAction func validateFields(sender: AnyObject) {
        
        self.username = self.usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.email = self.emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.password = self.passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (countElements(username) > 0) && (countElements(password) > 0) && (countElements(email) > 0){
            self.nextButton.enabled = true
        } else {
            self.nextButton.enabled = false
        }
    }
    
    func signUp() {
        
        var username = self.usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var email = self.emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var password = self.passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (countElements(username) == 0) || (countElements(password) == 0) || (countElements(email) == 0) {
                
                var alertView = UIAlertController(title: "Oops!", message: "Make Sure you enter a Name, username, password and email address!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
                
        } else {
            
            
            var user = PFUser()
            user.username = username
            user.password = password
            user.email = email
            
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if (error == nil) {
                    
                    self.performSegueWithIdentifier("setupBio", sender: self)
                    
                } else {
                    
                    let errorString = error.userInfo!
                    let string = errorString["error"] as NSString
                    
                    var alertView = UIAlertController(title: "Oops!", message: string,
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                }
            }
        }
    }

    
    func cancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func navBarSettings() {
        
        var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancel"))
        cancelButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationItem.leftBarButtonItem = cancelButton
        
        self.nextButton = UIBarButtonItem(title: "Sign Up", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("signUp"))
        nextButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationItem.rightBarButtonItem = nextButton
        
        self.navigationItem.title = "Sign Up"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        
    }


    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }

}
