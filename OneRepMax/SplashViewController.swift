//
//  SplashViewController.swift
//  OneRepMax
//
//  Created by Jake on 7/14/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.signUp.layer.borderColor = UIColor.whiteColor().CGColor
        self.signUp.layer.borderWidth = 1
        
        self.login.layer.borderColor = UIColor.whiteColor().CGColor
        self.login.layer.borderWidth = 1
//        self.signUp.backgroundColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
//        self.signUp.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
//        self.login.backgroundColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
//        self.login.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
    }
    
    
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
}
