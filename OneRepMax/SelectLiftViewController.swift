//
//  SelectLiftViewController.swift
//  OneRepMax
//
//  Created by Jake on 7/2/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit
import CoreLocation

class SelectLiftViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet var squatButton: UIButton!
    @IBOutlet var benchButton: UIButton!
    @IBOutlet var deadliftButton: UIButton!
    @IBOutlet var weightField: UITextField!
    
    var selectedLift = ""
    
    var locationManager = CLLocationManager()
    var location = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBar()

        self.buttonSettings()
        
        self.weightField.layer.borderColor = UIColor.whiteColor().CGColor
        self.weightField.layer.borderWidth = 3

        self.loadLocation()
    }

    @IBAction func dismissSelect(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buttonWasPressed(sender: UIButton) {
        
        if sender.tag == 1 {
            self.squatButton.layer.backgroundColor = UIColor.grayColor().CGColor
            self.benchButton.layer.backgroundColor = UIColor.clearColor().CGColor
            self.deadliftButton.layer.backgroundColor = UIColor.clearColor().CGColor
            
            self.squatButton.alpha = 1.0
            self.benchButton.alpha = 0.5
            self.deadliftButton.alpha = 0.5
            
            self.selectedLift = "squat"
            
        } else if sender.tag == 2 {
            self.benchButton.layer.backgroundColor = UIColor.grayColor().CGColor
            self.squatButton.layer.backgroundColor = UIColor.clearColor().CGColor
            self.deadliftButton.layer.backgroundColor = UIColor.clearColor().CGColor
            
            self.benchButton.alpha = 1.0
            self.squatButton.alpha = 0.5
            self.deadliftButton.alpha = 0.5
            
            self.selectedLift = "bench"
            
        } else {
            self.deadliftButton.layer.backgroundColor = UIColor.grayColor().CGColor
            self.benchButton.layer.backgroundColor = UIColor.clearColor().CGColor
            self.squatButton.layer.backgroundColor = UIColor.clearColor().CGColor
            
            self.deadliftButton.alpha = 1.0
            self.benchButton.alpha = 0.5
            self.squatButton.alpha = 0.5
            
            self.selectedLift = "deadlift"
            
        }
    }
    
    func addNavBar() {
        var navbar = UINavigationBar(frame: CGRectMake(0, 0, 320, 64))
        var navItem = UINavigationItem()
        
        var backBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismiss"))
        backBarButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        
        var postBarButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("post"))
        postBarButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        
        navItem.leftBarButtonItem = backBarButton
        navItem.rightBarButtonItem = postBarButton
        
        navbar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navbar.shadowImage = UIImage()
        navbar.translucent = true
        
        navbar.items = [navItem]
        self.view.addSubview(navbar)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func post() {
        
        var weight = self.weightField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if countElements(weight) == 0 || self.selectedLift == ""{
            
            var alertView = UIAlertController(title: "Oops!", message: "Make sure you select a lift and enter a weight!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            
        } else if self.weightField.text.toInt() < 45 || self.weightField.text.toInt() > 1500 {
        
            var alertView = UIAlertController(title: "Invalid Weight!", message: "Please enter an actual lift!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            
        } else {

            var user = PFUser.currentUser()
            
            var post = PFObject(className: "Post")
            post["user"] = user
            post["lift"] = self.selectedLift
            post["weight"] = self.weightField.text.toInt()
            
            user[selectedLift] = self.weightField.text.toInt()
            
            var point = PFGeoPoint(location: self.location)
            user["currentLocation"] = point
            
            user.saveInBackground()
            post.saveInBackground()
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = countElements(textField.text)
        let newstring = countElements(string)
        let newrange = range.length
        
        let newLength = text + newstring - newrange
        
        return (newLength > 4) ? false : true;
    }
    
    func buttonSettings() {
        
        self.squatButton.layer.borderWidth = 3
        self.squatButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.benchButton.layer.borderWidth = 3
        self.benchButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.deadliftButton.layer.borderWidth = 3
        self.deadliftButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.squatButton.layer.cornerRadius = 40
        self.benchButton.layer.cornerRadius = 40
        self.deadliftButton.layer.cornerRadius = 40
        
        self.squatButton.tag = 1
        self.benchButton.tag = 2
        self.deadliftButton.tag = 3
        
        self.squatButton.addTarget(self, action: Selector("buttonWasPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.benchButton.addTarget(self, action: Selector("buttonWasPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.deadliftButton.addTarget(self, action: Selector("buttonWasPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    func loadLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = 1000
//        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.locationManager.stopUpdatingLocation()
        
        var location : CLLocation = locations[0] as CLLocation
        self.location = location
    }
    
}
