//
//  BusListCell.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 20/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class BusListCell: UITableViewCell {

    @IBOutlet weak var lblSeats: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
//    @IBOutlet weak var lblTimings: UILabel!
    @IBOutlet weak var lblBusName: UILabel!
//    @IBOutlet weak var lblBusType: UILabel!
    @IBOutlet weak var lblBusCondition: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
