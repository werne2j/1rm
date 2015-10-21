//
//  LoginTableViewController.swift
//  OneRepMax
//
//  Created by Jake on 9/16/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController {
    
    var loginButton : UIBarButtonItem!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var username : String!
    var password : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.navBarSettings()
        
        self.addForgetButton()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false
        
        self.loginButton.enabled = false
        self.usernameField.becomeFirstResponder()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject!) -> Bool {
        
        if identifier == "resetPassword" {
            return false
        }
        
        return true
    }
    
    func addForgetButton() {
        var forgotPassword = UIButton(frame: CGRectMake(80, 110, 160, 30))
        forgotPassword.setTitle("Forget Password?", forState: UIControlState.Normal)
        forgotPassword.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1.0, alpha: 1.0), forState: UIControlState.Normal)
        forgotPassword.addTarget(self, action: Selector("gotoReset"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(forgotPassword)
    }
    
    func gotoReset() {
        
        performSegueWithIdentifier("resetPassword", sender: self)
        
    }
    
    func cancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func navBarSettings() {
        var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancel"))
        cancelButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationItem.leftBarButtonItem = cancelButton
        
        self.loginButton = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("login"))
        self.loginButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationItem.rightBarButtonItem = loginButton
        
        self.navigationItem.title = "Log In"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
    }
    
    @IBAction func validateFields(sender: AnyObject) {
        self.username = self.usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.password = self.passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (countElements(username) > 0) && (countElements(password) > 0) {
            self.loginButton.enabled = true
        } else {
            self.loginButton.enabled = false
        }

    }
    
    func login() {
        
        self.username = self.usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.password = self.passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (countElements(username) == 0) || (countElements(password) == 0) {
            
            var alertView = UIAlertController(title: "Oops!", message: "Make Sure you enter a username and password!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            
        } else {
            
            // Parse Login
            
            PFUser.logInWithUsernameInBackground(username, password:password) {
                (user: PFUser!, error: NSError!) -> Void in
                if (user != nil) {
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
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

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }

}
