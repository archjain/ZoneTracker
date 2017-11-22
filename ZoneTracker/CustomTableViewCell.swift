//
//  CustomTableViewCell.swift
//  ZoneTracker
//
//  Created by Archit Jain on 11/21/17.
//  Copyright © 2017 Holtec. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var asset: UILabel!
    @IBOutlet var rssi: UILabel!
    @IBOutlet var proximity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

