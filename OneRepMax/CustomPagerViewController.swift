//
//  CustomPagerViewController.swift
//  OneRepMax
//
//  Created by Jake on 7/2/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class CustomPagerViewController: PagerViewController, ChildVCDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildren()
        self.checkForUser()
        self.scrollSettings()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
    }
    
    func addChildren() {
        let vc1 : MainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("1RM") as MainViewController
        let vc2 : ProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Profile") as ProfileViewController
        let vc3 : FeedViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedContainer") as FeedViewController
        
        vc1.delegate = self
        vc2.delegate = self
        vc3.delegate = self
        
        self.addChildViewController(vc3)
        self.addChildViewController(vc1)
        self.addChildViewController(vc2)
    }

    func checkForUser() {
        var currentUser = PFUser.currentUser()
        
        if (currentUser == nil) {
            self.performSegueWithIdentifier("showLogin", sender: self)
        }
    }
    
    func scrollSettings() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = true
        self.extendedLayoutIncludesOpaqueBars = false
    }
    
    func childVC(childVC: UIViewController, scrollButton: UIBarButtonItem) {
        self.scrollView.setContentOffset(CGPoint(x: 320, y: 0), animated: true)
    }
    
    func reset() {
        self.scrollView.setContentOffset(CGPoint(x: 320, y: 0), animated: false)
    }
    
    func returnToRoot() {
        self.dismissViewControllerAnimated(false, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
