//
//  SetupTableViewController.swift
//  OneRepMax
//
//  Created by Jake on 9/17/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit
import CoreLocation

class SetupTableViewController: UITableViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    var locationManager = CLLocationManager()
    var location = CLLocation()
    
    @IBOutlet var avatar: UIImageView!
    var imagePicker = UIImagePickerController()
    var image : UIImage? = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.navBarSettings()
        
        self.loadLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }

    func navBarSettings() {
        self.navigationItem.hidesBackButton = true
        
        var finishButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("setup"))
        finishButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationItem.rightBarButtonItem = finishButton
        
        self.navigationItem.title = "Setup Account"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
    }
    
    func setup () {
        
        let user = PFUser.currentUser()
        
        var name = self.nameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var height = self.heightField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var weight = self.weightField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        user["name"] = name
        user["height"] = height
        user["weight"] = weight
        
        var point = PFGeoPoint(location: self.location)
        user["currentLocation"] = point
        
        if self.image?.size.height != 0 && self.image?.size.width != 0 {
            
            var file = PFFile()
            var fileName = NSString()
            var fileData = NSData()
            var fileType = NSString()
            
            if self.image?.size.width > 200 {
                var newImage = self.resizeImage(self.image!, width: 200)
                fileData = UIImagePNGRepresentation(newImage)
            } else {
                fileData = UIImagePNGRepresentation(self.image)
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-h-mm"
            let timestamp = dateFormatter.stringFromDate(NSDate())
            
            fileName = "\(user.username)_avatar\(timestamp).png"
            fileType = "image"
            file = PFFile(name: fileName, data: fileData)
            user["avatar"] = file
        }
        
        user.saveInBackground()
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func loadLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = 1000
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.locationManager.stopUpdatingLocation()
        
        var location : CLLocation = locations[0] as CLLocation
        self.location = location
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            return 44
        }
    }
    
    // Photo
    
    @IBAction func callActionSheet(sender: AnyObject) {
        
        var sheet: UIActionSheet = UIActionSheet()
        sheet.delegate = self
        sheet.addButtonWithTitle("Cancel")
        sheet.addButtonWithTitle("Choose Existing")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            sheet.addButtonWithTitle("Take Picture")
        }
        sheet.cancelButtonIndex = 0
        sheet.showInView(self.view)
        
    }
    
    func actionSheet(sheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.addPhoto()
        case 2:
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.addPhoto()
        default:
            break
        }
        
    }
    
    func addPhoto() {
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        
        self.imagePicker.mediaTypes = [kUTTypeImage as NSString]
        
        self.presentViewController(self.imagePicker, animated: false, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if self.imagePicker.sourceType == UIImagePickerControllerSourceType.Camera {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
        }
        
        self.avatar.image = self.image
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
        
        var oldWidth = image.size.width
        var scale = width / oldWidth
        
        var newHeight = image.size.height * scale
        var newWidth = oldWidth * scale
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
