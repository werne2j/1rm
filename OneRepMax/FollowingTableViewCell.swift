//
//  FollowingTableViewCell.swift
//  OneRepMax
//
//  Created by Jake on 7/29/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class FollowingTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unfollowButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
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
