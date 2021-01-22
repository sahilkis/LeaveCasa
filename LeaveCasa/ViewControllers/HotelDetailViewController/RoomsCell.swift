//
//  RoomsCell.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 23/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RoomsCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblMealType: UILabel!
    @IBOutlet weak var lblRefundable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
