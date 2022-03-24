//
//  BookingCell.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 23/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import SearchTextField
import DropDown

class BookingCell: UITableViewCell {

    @IBOutlet weak var txtTitle: SearchTextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtState: SearchTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
