//
//  FlightDetailCell.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 25/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class FlightDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblSourceCode: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblDestinationCode: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFlightNo: UILabel!
    @IBOutlet weak var lblTerminal: UILabel!
    @IBOutlet weak var lblGate: UILabel!
    @IBOutlet weak var lblSeats: UILabel!
    @IBOutlet weak var btnFareRules: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
