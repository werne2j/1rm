//
//  ResetPasswordTableViewController.swift
//  OneRepMax
//
//  Created by Jake on 9/16/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class ResetPasswordTableViewController: UITableViewController {

    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)

        var resetButton = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("reset"))
        resetButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationItem.rightBarButtonItem = resetButton
        
        var backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("dismiss"))
        backButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Reset Password"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.emailField.becomeFirstResponder()
    }
    
    func reset() {
        var email = self.emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        PFUser.requestPasswordResetForEmailInBackground(email)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }

}
