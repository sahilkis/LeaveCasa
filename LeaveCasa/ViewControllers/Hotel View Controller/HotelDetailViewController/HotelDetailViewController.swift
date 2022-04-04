import UIKit
import SDWebImage

class HotelDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var facilitiesCollectionView: UICollectionView!
    @IBOutlet weak var facilitiesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblHotelTitle: UILabel!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblHotelAddress: UILabel!
    @IBOutlet weak var lblHotelPrice: UILabel!
    @IBOutlet weak var btnOverview: UIButton!
    @IBOutlet weak var underlineOverview: UIView!
    @IBOutlet weak var btnFacilities: UIButton!
    @IBOutlet weak var underlineFacilities: UIView!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var underlineTerms: UIView!
    @IBOutlet weak var hotelRatingView: FloatRatingView!
    @IBOutlet weak var lblRefundable: UILabel!
    @IBOutlet weak var lblNoRooms: UILabel!
    
    var hotels: Hotels?
    var hotelDetail: HotelDetail?
    var markups = [Markup]()
    var facilities = [String]()
    var jsonResponse = [[String: AnyObject]]()
    var searchId = ""
    var logId = 0
    var checkIn = ""
    var checkOut = ""
    var finalRooms = [[String: AnyObject]]()
    var selectedTab = 0 // 0 - Overview, 1 - Facilities, 2 - TermsAndCondn
    var numberOfRooms = 1
    var numberOfAdults = 1
    var numberOfChild = 0
    var numberOfNights = 1
    var ageOfChildren: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: CellIds.ImagesCell, bundle: nil), forCellWithReuseIdentifier: CellIds.ImagesCell)
        tableView.register(UINib.init(nibName: CellIds.RoomsCell, bundle: nil), forCellReuseIdentifier: CellIds.RoomsCell)
        
        setUpTab()
        setupData()
        setLeftbarButton()
        fetchHotelImages()
        fetchHotelDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
        self.facilitiesCollectionView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
        self.facilitiesCollectionView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] {
            if let newSize = newValue as? CGSize {
                if (object as? UITableView) != nil {
                    self.tableViewHeightConstraint.constant = newSize.height
                }
                else if (object as? UICollectionView) != nil {
                    self.facilitiesCollectionViewHeightConstraint.constant = newSize.height
                }
            }
        }
        
    }
    
    func setLeftbarButton() {
        self.lblHotelTitle.text = hotels?.sName ?? ""
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = self.jsonResponse.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: .valueChanged)
    }
    
    private func setupData() {
        
        let hotel: Hotels?
        hotel = self.hotels
        
        if let address = hotel?.sAddress {
            self.lblHotelAddress.text = address
        }
        if let name = hotel?.sName {
            self.lblHotelName.text = name
        }
        if let minRate = hotel?.iMinRate {
            if let nonRefundable = minRate.sNonRefundable as? Bool {
                if nonRefundable {
                    self.lblRefundable.text = Strings.NON_REFUNDABLE
                } else {
                    self.lblRefundable.text = Strings.REFUNDABLE
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
                self.lblHotelPrice.text = "₹\(String(format: "%.0f", price))"
            }
        }
        if let rating = hotel?.iCategory {
            self.hotelRatingView.rating = Double(rating)
        }
        
        // TODO: pending
        if self.hotelDetail?.rates.count ?? 0 > 0 {
            self.lblNoRooms.isHidden = true
        }
        else{
            self.lblNoRooms.isHidden = false
        }
        
    }
    
    private func setUpTab() {
        let selectedColor = LeaveCasaColors.PINK_COLOR
        let unselectedColor = LeaveCasaColors.LIGHT_GRAY_COLOR
        let clearColor = UIColor.clear
        
        switch selectedTab
        {
        case 0:
            btnOverview.setTitleColor(selectedColor, for: .normal)
            underlineOverview.backgroundColor = selectedColor
            
            btnFacilities.titleLabel?.textColor = unselectedColor
            underlineFacilities.backgroundColor = clearColor
            
            btnTerms.titleLabel?.textColor = unselectedColor
            underlineTerms.backgroundColor = clearColor
            break
            
        case 1:
            btnOverview.titleLabel?.textColor = unselectedColor
            underlineOverview.backgroundColor = clearColor
            
            btnFacilities.setTitleColor(selectedColor, for: .normal)
            underlineFacilities.backgroundColor = selectedColor
            
            btnTerms.titleLabel?.textColor = unselectedColor
            underlineTerms.backgroundColor = clearColor
            break
            
        case 2:
            btnOverview.titleLabel?.textColor = unselectedColor
            underlineOverview.backgroundColor = clearColor
            
            btnFacilities.titleLabel?.textColor = unselectedColor
            underlineFacilities.backgroundColor = clearColor
            
            btnTerms.setTitleColor(selectedColor, for: .normal)
            underlineTerms.backgroundColor = selectedColor
            break
        default: break
            
        }
        
        self.facilitiesCollectionView.reloadData()
    }
}

// MARK: - UIBUTTON ACTIONS
extension HotelDetailViewController {
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * collectionView.frame.size.width
        collectionView.setContentOffset(CGPoint.init(x: x, y: 0), animated: true)
    }
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOverviewAction(_ sender: UIButton) {
        selectedTab = 0
        setUpTab()
    }
    
    @IBAction func btnFacilitiesAction(_ sender: UIButton) {
        selectedTab = 1
        setUpTab()
    }
    
    @IBAction func btnTermsNCondAction(_ sender: UIButton) {
        selectedTab = 2
        setUpTab()
    }
    
    @IBAction func btnBookNowAction(_ sender: UIButton) {
        if let hotelDetails = self.hotelDetail , let vc = ViewControllerHelper.getViewController(ofType: .HotelBookingViewController) as? HotelBookingViewController {
            vc.hotelDetail = hotelDetails
            vc.selectedRoomRate = sender.tag
            vc.markups = self.markups
            vc.searchId = self.searchId
            vc.logId = logId
            vc.markups = markups
            vc.checkIn = checkIn
            vc.checkOut = checkOut
            vc.finalRooms = finalRooms
            vc.numberOfRooms = self.numberOfRooms
            vc.numberOfAdults = self.numberOfAdults
            vc.numberOfChild = self.numberOfChild
            vc.numberOfNights = self.numberOfNights
            vc.ageOfChildren = self.ageOfChildren
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cancellationPolicyClicked(_ sender: UIButton) {
        let dict = self.hotelDetail?.rates[sender.tag]
        
        if let cancellationPolicy = dict?.sCancellationPolicy {
            if let vc = ViewControllerHelper.getViewController(ofType: .HotelCancellationPolicyViewController) as? HotelCancellationPolicyViewController {
                vc.hotelCancellationPolicy = cancellationPolicy
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension HotelDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return jsonResponse.count
        }
        else if selectedTab == 0 {
            return 1
        }
        else if selectedTab == 1 {
            return facilities.count
        }
        else if selectedTab == 2 {
            return 5
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.ImagesCell, for: indexPath) as? ImagesCell {
            let dict = jsonResponse[indexPath.row]
            
            if let imageUrl = dict[WSResponseParams.WS_RESP_PARAM_URL] as? String {
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
            
            return cell
        }
        else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.FacilitiesCell, for: indexPath) as? FacilitiesCell {
            
            if selectedTab == 0 {
                cell.icon.isHidden = true
            } else {
                cell.icon.isHidden = false
            }
            
            if selectedTab == 0 {
                let data = Data((hotelDetail?.sDescription ?? "").utf8)
                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                    cell.label.attributedText = attributedString
                }
                else {
                    cell.label.text = hotelDetail?.sDescription ?? ""
                }
            }
            
            if selectedTab == 1 {
                cell.label.text = facilities[indexPath.row]
            }
            
            cell.label.sizeToFit()
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        else if collectionView == self.facilitiesCollectionView {
            
            var height = collectionView.frame.height
            var width = collectionView.frame.width
            if selectedTab == 1 {
                width = collectionView.frame.width/2
            }
            let label = UILabel(frame: CGRect.zero)
            label.frame.size.width = width - 40
            label.text = "Label"
            label.numberOfLines = 0
            label.sizeToFit()
            
            height = label.frame.height
            
            return CGSize.init(width: width, height: height + 20)
        }
        else {
            return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
}

// MARK: - UITABLEVIEW METHODS
extension HotelDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hotelDetail?.rates.count ?? 0 > 0 {
            self.lblNoRooms.isHidden = true
        }
        else{
            self.lblNoRooms.isHidden = false
        }
        
        return self.hotelDetail?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.RoomsCell, for: indexPath) as! RoomsCell
        
        let dict = hotelDetail?.rates[indexPath.row]
        
        if var price = dict?.sPrice as? Double {
            for i in 0..<markups.count {
                let markup: Markup?
                markup = markups[i]
                if markup?.starRating == hotels?.iCategory {
                    if markup?.amountBy == Strings.PERCENT {
                        price += (price * (markup?.amount ?? 0) / 100)
                    } else {
                        price += (markup?.amount ?? 0)
                    }
                }
            }
            cell.lblPrice.text = "₹\(String(format: "%.0f", price))"
        }
        
        if let boardingDetails = dict?.sBoardingDetails as? [String] {
            for i in 0..<boardingDetails.count {
                cell.lblMealType.text = boardingDetails[i]
            }
        }
        
        //        if let nonRefundable = dict[WSResponseParams.WS_RESP_PARAM_NON_REFUNDABLE] as? Bool {
        //            if nonRefundable {
        //                cell.lblRefundable.text = Strings.NON_REFUNDABLE
        //            } else {
        //                cell.lblRefundable.text = Strings.REFUNDABLE
        //            }
        //        }
        
        if let rooms = dict?.sRooms {
            for i in 0..<rooms.count {
                let newDict = rooms[i]
                
                if let roomDescription = newDict.sRoomType as? String {
                    cell.lblName.text = "1 x \(roomDescription)"
                }
            }
        }
        
        if let supportsCancellation = dict?.sSupportsCancellation {
            if supportsCancellation {
                cell.btnCancellationPolicy.setTitle("Cancellation policy", for: UIControl.State())
            }
            else {
                cell.btnCancellationPolicy.setTitle("No cancellation", for: UIControl.State())
            }
        }
        
        cell.btnBookNow.tag = indexPath.row
        cell.btnCancellationPolicy.tag = indexPath.row
        
        cell.btnBookNow.addTarget(self, action: #selector(btnBookNowAction(_:)), for: .touchUpInside)
        cell.btnCancellationPolicy.addTarget(self, action: #selector(cancellationPolicyClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let dict = prices[indexPath.row]
    //
    //        if let cancellationPolicy = dict[WSResponseParams.WS_RESP_PARAM_CANCELLATION_POLICY] as? [String: AnyObject] {
    //            if let vc = ViewControllerHelper.getViewController(ofType: .HotelCancellationPolicyViewController) as? HotelCancellationPolicyViewController {
    //                vc.hotelCancellationPolicy = cancellationPolicy
    //                self.navigationController?.pushViewController(vc, animated: true)
    //            }
    //        }
    //    }
}

// MARK: - UISCROLLVIEW DELEGATE
extension HotelDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

// MARK: - API CALL
extension HotelDetailViewController {
    func fetchHotelImages() {
        if WSManager.isConnectedToInternet() {
            WSManager.wsCallGetHotelImages(hotels?.sHotelCode ?? "", success: { (response, message) in
                self.jsonResponse = response
                self.setupPageControl()
                self.collectionView.reloadData()
            }, failure: { (error) in
                
            })
        } else {
            
        }
    }
    
    func fetchHotelDetail() {
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [WSResponseParams.WS_RESP_PARAM_SEARCH_ID: searchId as AnyObject,
                                               WSResponseParams.WS_RESP_PARAM_HOTEL_CODE: hotels?.sHotelCode as AnyObject,
                                               WSResponseParams.WS_RESP_PARAM_LOGID: logId as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_CHECKIN: checkIn as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_CHECKOUT: checkOut as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_ROOMS: finalRooms as AnyObject]
            WSManager.wsCallFetchHotelDetail(params, success: { (response, searchId)  in
                self.setData(response)
                self.searchId = searchId
            }, failure: { (error) in
                
            })
        } else {
            
        }
    }
    
    func setData(_ response: HotelDetail) {
        hotelDetail = response
        
        if let address = hotelDetail?.sAddress {
            lblHotelAddress.text = address
        }
        
        if let name = hotelDetail?.sName {
            lblHotelName.text = name
        }
        
        if let rating = hotelDetail?.iCategory {
            hotelRatingView.rating = Double(rating)
        }
        
        if let facility = hotelDetail?.sFacilities {
            facilities = facility.components(separatedBy: "; ")
        }
        
        if let minRate = hotelDetail?.rates {
            
            let dict = minRate[0]
            if var price = dict.sPrice as? Double {
                for i in 0..<markups.count {
                    let markup: Markup?
                    markup = markups[i]
                    if markup?.starRating == hotelDetail?.iCategory {
                        if markup?.amountBy == Strings.PERCENT {
                            price += (price * (markup?.amount ?? 0) / 100)
                        } else {
                            price += (markup?.amount ?? 0)
                        }
                    }
                }
                
                lblHotelPrice.text = "₹\(String(format: "%.0f", price))"
            }
        }
        
        self.tableView.reloadData()
        self.facilitiesCollectionView.reloadData()
    }
}
