import UIKit
import SDWebImage

class HotelListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHotelCount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var results = [Results]()
    var markups = [Markup]()
    var checkInDate = ""
    var checkIn = ""
    var checkOut = ""
    var finalRooms = [[String: AnyObject]]()
    var hotelCount = ""
    var logId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftbarButton()
        lblHotelCount.text = "\(hotelCount) Hotels found"
        lblDate.text = checkInDate
//        tableView.register(UINib.init(nibName: CellIds.HotelListCell, bundle: nil), forCellReuseIdentifier: CellIds.HotelListCell)
    }
    
    func setLeftbarButton() {
        self.title = " "
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
}

// MARK: - UIBUTTON ACTIONS
extension HotelListViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITABLEVIEW METHODS
extension HotelListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2// results[section].hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.HotelListCell, for: indexPath) as! HotelListCell
        /*
        let hotels = results[indexPath.section].hotels

        let hotel: Hotels?
        hotel = hotels[indexPath.row]
        
        if let address = hotel?.sAddress {
            cell.lblHotelAddress.text = address
        }
        if let name = hotel?.sName {
            cell.lblHotelName.text = name
        }
        if let minRate = hotel?.iMinRate {
            if let nonRefundable = minRate[WSResponseParams.WS_RESP_PARAM_NON_REFUNDABLE] as? Bool {
                if nonRefundable {
                    cell.lblRefundable.text = Strings.NON_REFUNDABLE
                } else {
                    cell.lblRefundable.text = Strings.REFUNDABLE
                }
            }
            if var price = minRate[WSResponseParams.WS_RESP_PARAM_PRICE] as? Int {
                for i in 0..<markups.count {
                    let markup: Markup?
                    markup = markups[i]
                    if markup?.starRating == hotel?.iCategory {
                        if markup?.amountBy == Strings.PERCENT {
                            price += (price * (markup?.amount ?? 0) / 100)
                        } else {
                            price += (markup?.amount ?? 0)
                        }
                    }
                }
                cell.lblHotelPrice.text = "₹\(String(price))"
            }
        }
        if let rating = hotel?.iCategory {
            cell.ratingView.rating = Double(rating)
        }
        if let image = hotel?.sImages {
            if let imageUrl = image[WSResponseParams.WS_RESP_PARAM_URL] as? String {
                let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
                    //print(image)
                    if (image == nil) {
                        
                    }
                }
                
                if let imageStr = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    if let url = URL(string: imageStr) {
                        cell.imgHotel.sd_setImage(with: url, completed: block)
                    }
                }
            }
        }
        */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = results[indexPath.section]
        
        if let vc = ViewControllerHelper.getViewController(ofType: .HotelDetailViewController) as? HotelDetailViewController {
//            vc.hotels = dict.hotels[indexPath.row]
//            vc.searchId = dict.searchId
//            vc.logId = logId
//            vc.markups = markups
//            vc.checkIn = checkIn
//            vc.checkOut = checkOut
//            vc.finalRooms = finalRooms
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
