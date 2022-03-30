//
//  FlightListRoundCell.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 30/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class FlightListRoundCell: UITableViewCell {
    
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFLightInfo: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
//    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblStops: UILabel!
    @IBOutlet weak var lblAirline: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
