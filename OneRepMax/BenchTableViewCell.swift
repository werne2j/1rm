//
//  BenchTableViewCell.swift
//  OneRepMax
//
//  Created by Jake on 9/3/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class BenchTableViewCell: UITableViewCell {

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: PFImageView!
    
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
