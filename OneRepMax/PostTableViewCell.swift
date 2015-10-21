//
//  PostTableViewCell.swift
//  OneRepMax
//
//  Created by Jake on 7/10/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet var postLabel: UILabel!
    @IBOutlet var liftField: UITextField!
    @IBOutlet var weightField: UITextField!
    @IBOutlet var createdLabel: UILabel!
    

    @IBOutlet var liftImage: PFImageView!
    @IBOutlet var thumbnail: PFImageView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override var layoutMargins: UIEdgeInsets {
        get { return UIEdgeInsetsZero }
        set(newVal) {}
    }

}
