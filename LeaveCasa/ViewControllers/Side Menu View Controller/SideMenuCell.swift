//
//  SideMenuCell.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 21/04/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbldes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
