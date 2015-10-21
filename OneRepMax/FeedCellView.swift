//
//  FeedCellView.swift
//  OneRepMax
//
//  Created by Jake on 7/10/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class FeedCellView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    
    // Only override drawRect: if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect)
//    {
//        
//        self.layer.shadowColor = UIColor.blackColor().CGColor
//        self.layer.shadowOpacity = 0.2
//        self.layer.shadowRadius = 3
//        self.layer.shadowOffset = CGSizeMake(0, 0)
//    }
    override var layoutMargins: UIEdgeInsets {
        get { return UIEdgeInsetsZero }
        set(newVal) {}
    }

}
