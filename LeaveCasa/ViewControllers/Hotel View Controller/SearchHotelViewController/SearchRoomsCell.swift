import UIKit

class SearchRoomsCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
//    @IBOutlet weak var lblRoomCount: UILabel!
//    @IBOutlet weak var lblAdultCount: UILabel!
    @IBOutlet weak var lblChildCount: UILabel!
//    @IBOutlet weak var btnPlusAdult: UIButton!
//    @IBOutlet weak var btnMinusAdult: UIButton!
    @IBOutlet weak var btnPlusChild: UIButton!
    @IBOutlet weak var btnMinusChild: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
