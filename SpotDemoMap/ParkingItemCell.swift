//
//  ParkingItemCell.swift
//  SpotDemoMap
//
//  Created by Nick Brandaleone on 6/8/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

/*
    This class handles the individual cells in the TableView.
    There are two labels (and their attributes) that we manage.
*/

import UIKit

class ParkingItemCell: UITableViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var parkingItem: ParkingSpot? {
        
        // Swift property observers
        // We update the labels in the cell upon setting the variable
        didSet {
            if let item = parkingItem {
                statusLabel.text = item.title
                summaryLabel.text = item.summary
                statusLabel.textColor = item.textColor
            } else {
                statusLabel.text = nil
                summaryLabel.text = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
