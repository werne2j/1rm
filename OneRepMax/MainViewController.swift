//
//  MainViewController.swift
//  OneRepMax
//
//  Created by Jake on 7/1/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit
import QuartzCore

@objc protocol ChildVCDelegate {
    func childVC(childVC: UIViewController, scrollButton:UIBarButtonItem)
    func reset()
}

class MainViewController: UIViewController {

    weak var delegate: ChildVCDelegate?
    
    @IBOutlet var maxButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBorder()
        self.addBackground()
        self.buttonSettings()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }

    func addBorder() {
        
        let mainViewSize = self.view.bounds.size
        let borderWidth = 0.5 as CGFloat
        let borderColor = UIColor.blackColor().CGColor
        
        var leftView = UIView(frame: CGRectMake(0, 0, borderWidth, mainViewSize.height))
        var rightView = UIView(frame: CGRectMake(mainViewSize.width - borderWidth, 0, borderWidth, mainViewSize.height))
        
        leftView.opaque = true
        rightView.opaque = true
        leftView.layer.backgroundColor = borderColor
        rightView.layer.backgroundColor = borderColor
        
        leftView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin
        rightView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin
        self.view.addSubview(leftView)
        self.view.addSubview(rightView)
    }

    func informDelegateToScrollMethod(sender: AnyObject) {
        self.delegate?.childVC(self, scrollButton:sender as UIBarButtonItem)
    }
    
    func addBackground() {

        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        
        let cor1 = UIColor(red: 0.314, green: 0.314, blue: 0.341, alpha: 1).CGColor
        let cor2 = UIColor(red: 0.086, green: 0.082, blue: 0.082, alpha: 1).CGColor
        let arrayColors : Array <AnyObject> = [cor1, cor2]
        
        gradient.colors = arrayColors
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }

    func buttonSettings() {
        self.maxButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.maxButton.layer.borderWidth = 3
        
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor(red: 0.373, green: 0.373, blue: 0.373, alpha: 1).CGColor)
        CGContextFillRect(context, rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.maxButton.setBackgroundImage(image, forState: UIControlState.Highlighted)
        self.maxButton.layer.masksToBounds = true
        self.maxButton.layer.cornerRadius = 90
    }
}
