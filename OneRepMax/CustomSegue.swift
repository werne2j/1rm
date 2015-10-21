//
//  CustomSegue.swift
//  OneRepMax
//
//  Created by Jake on 7/23/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
   
    override func perform() {
        
        
        let source = self.sourceViewController as UIViewController
        
        source.navigationController?.pushViewController(self.destinationViewController as UIViewController, animated: false)
        
        
    }
}
