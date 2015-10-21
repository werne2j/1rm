//
//  EditProfileTableViewController.swift
//  OneRepMax
//
//  Created by Jake on 10/9/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avatar: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var image : UIImage? = UIImage()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.navBarSettings()
        
        var user = PFUser.currentUser()
        
        self.username.text = user.objectForKey("username") as String?
        self.name.text = user.objectForKey("name") as String?
        self.email.text = user.objectForKey("email") as String?
        self.height.text = user.objectForKey("height") as String?
        self.weight.text = user.objectForKey("weight") as String?
        
        if (user.objectForKey("avatar") != nil) {
            var file = user.objectForKey("avatar") as PFFile
            
            file.getDataInBackgroundWithBlock({ (data, error) -> Void in
                self.avatar.image = UIImage(data: data)
            })
        }
        
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.cornerRadius = 22

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }

    
    func navBarSettings() {
        
        var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("back"))
        cancelButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationItem.leftBarButtonItem = cancelButton
        
        var saveBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("saveProfile"))
        saveBarButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        self.navigationItem.title = "Edit Profile"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        
    }
    
    func saveProfile() {
        
        var user = PFUser.currentUser()
        
        user.username = self.username.text
        user["name"] = self.name.text
        user["email"] = self.email.text
        user["height"] = self.height.text
        user["weight"] = self.weight.text
        
        if self.image?.size.height != 0 && self.image?.size.width != 0 {
            
            var file = PFFile()
            var fileName = NSString()
            var fileData = NSData()
            var fileType = NSString()
            
            
            if self.image?.size.width > 200 {
                self.image = self.resizeImage(self.image!, width: 200)
            }
            
            fileData = UIImagePNGRepresentation(self.image)

            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-h-mm"
            let timestamp = dateFormatter.stringFromDate(NSDate())
            
            fileName = "\(user.username)_avatar\(timestamp).png"
            fileType = "image"
            file = PFFile(name: fileName, data: fileData)
            user["avatar"] = file
        }


        user.saveInBackground()

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
    
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
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

}
