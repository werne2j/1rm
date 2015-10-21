//
//  SearchViewCell.swift
//  OneRepMax
//
//  Created by Jake on 9/11/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class SearchViewCell: PFTableViewCell {
   
    @IBOutlet weak var userImage: PFImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    
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
