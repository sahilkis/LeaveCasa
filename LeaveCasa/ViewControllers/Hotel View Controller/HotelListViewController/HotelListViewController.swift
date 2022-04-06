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
    var cityCodeStr = ""
    var finalRooms = [[String: AnyObject]]()
    var hotelCount = ""
    var logId = 0
    var currentRequest = 0
    var numberOfRooms = 1
    var numberOfAdults = 1
    var numberOfChild = 0
    var numberOfNights = 1
    var ageOfChildren: [Int] = []
    var selectedRatings: [Int] = []
    var totalRequest = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftbarButton()
        setRightbarButton()

        lblHotelCount.text = "\(hotelCount) Hotels found"
        lblDate.text = checkInDate
    }
    
    func setLeftbarButton() {
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setRightbarButton() {
        let rightBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.THREE_DOTS, style: .plain, target: self, action: #selector(rightBarButton(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

// MARK: - UIBUTTON ACTIONS
extension HotelListViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        if let vc = ViewControllerHelper.getViewController(ofType: .HotelFilterViewController) as? HotelFilterViewController {
            vc.delegate = self
            vc.selectedRatings = self.selectedRatings
            
            self.present(vc, animated: true, completion: nil)
            // self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HotelListViewController: HotelFilterDelegate {
    func applyFilter(rating: [Int]) {
        self.hotelCount = "0"
        self.currentRequest = 0
        self.results = []
        self.selectedRatings = rating
        self.tableView.reloadData()
        
        Helper.showLoader(onVC: self, message: "")
        self.searchHotel()
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITABLEVIEW METHODS
extension HotelListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results[section].hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.HotelListCell, for: indexPath) as! HotelListCell
        
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
            if let nonRefundable = minRate.sNonRefundable as? Bool {
                if nonRefundable {
                    cell.lblRefundable.text = Strings.NON_REFUNDABLE
                } else {
                    cell.lblRefundable.text = Strings.REFUNDABLE
                }
            }
            
            if var price = minRate.sPrice as? Double {
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
                cell.lblHotelPrice.text = "₹\(String(format: "%.0f", price))"
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = results[indexPath.section]
        
        if let vc = ViewControllerHelper.getViewController(ofType: .HotelDetailViewController) as? HotelDetailViewController {
            vc.hotels = dict.hotels[indexPath.row]
            vc.searchId = dict.searchId
            vc.logId = logId
            vc.markups = markups
            vc.checkIn = checkIn
            vc.checkOut = checkOut
            vc.finalRooms = finalRooms
            vc.numberOfRooms = dict.sNoOfRooms
            vc.numberOfAdults = dict.sNoOfAdults
            vc.numberOfChild = dict.sNoOfChildren
            vc.numberOfNights = dict.sNoOfNights
            vc.ageOfChildren = self.ageOfChildren
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentRequest != Int(totalRequest) {
            if results.count - 1 == indexPath.section {
                if results[indexPath.section].hotels.count - 1 == indexPath.row {
                    currentRequest += 1
                    
                    Helper.showLoader(onVC: self, message: "")
                    self.searchHotel()
                }
            }
        }
    }
}

// MARK: - API CALL
extension HotelListViewController {
    func searchHotel() {
        if WSManager.isConnectedToInternet() {
            var params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_CURRENT_REQUEST: currentRequest as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_DESTINATION_CODE: cityCodeStr as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_CHECKIN: checkIn as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_CHECKOUT: checkOut as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_ROOMS: finalRooms as AnyObject,
                                               
            ]
            
            if !selectedRatings.isEmpty {
                params[WSRequestParams.WS_REQS_PARAM_STAR_RATING] = selectedRatings as AnyObject
            }
            
            WSManager.wsCallFetchHotels(params, success: { (results, markup, logId) in
                Helper.hideLoader(onVC: self)
                
                let count = results.reduce(0) {$0 + $1.numberOfHotels}
                let newCount = (Int(self.hotelCount) ?? 0) + count
                self.hotelCount = "\(newCount)"
                self.lblHotelCount.text = "\(self.hotelCount) Hotels found"
                
                self.results += results
                self.tableView.reloadData()
            }, failure: { (error) in
                Helper.hideLoader(onVC: self)
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.hideLoader(onVC: self)
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                self.searchHotel()
            })
        }
    }
}
