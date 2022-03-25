//
//  HotelListCell.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 20/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class HotelListCell: UITableViewCell {

    @IBOutlet weak var imgHotel: UIImageView!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblHotelAddress: UILabel!
    @IBOutlet weak var lblHotelPrice: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
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
