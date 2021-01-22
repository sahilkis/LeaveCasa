//
//  HotelDetailViewController.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 20/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class HotelDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblHotelAddress: UILabel!
    @IBOutlet weak var lblHotelPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnFacilities: UIButton!
    @IBOutlet weak var hotelRatingView: FloatRatingView!
    
    var hotels: Hotels?
    var markups = [Markup]()
    var facilities = [String]()
    var jsonResponse = [[String: AnyObject]]()
    var prices = [[String: AnyObject]]()
    var searchId = ""
    var logId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: CellIds.ImagesCell, bundle: nil), forCellWithReuseIdentifier: CellIds.ImagesCell)
        tableView.register(UINib.init(nibName: CellIds.RoomsCell, bundle: nil), forCellReuseIdentifier: CellIds.RoomsCell)
        setLeftbarButton()
        fetchHotelImages()
        fetchHotelDetail()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] {
            if let newSize = newValue as? CGSize {
                self.tableViewHeightConstraint.constant = newSize.height
            }
        }
    }
    
    func setLeftbarButton() {
        self.title = hotels?.sName ?? ""
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = self.jsonResponse.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: .valueChanged)
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
    
    @IBAction func facilitiesClicked(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .FacilitiesViewController) as? FacilitiesViewController {
            vc.facilities = self.facilities
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension HotelDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.ImagesCell, for: indexPath) as! ImagesCell
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UITABLEVIEW METHODS
extension HotelDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.RoomsCell, for: indexPath) as! RoomsCell
        
        let dict = prices[indexPath.row]
        
        if var price = dict[WSResponseParams.WS_RESP_PARAM_PRICE] as? Int {
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
            cell.lblPrice.text = "₹\(String(price))"
        }
        
        if let boardingDetails = dict[WSResponseParams.WS_RESP_PARAM_BOARDING_DETAIL] as? [String] {
            for i in 0..<boardingDetails.count {
                cell.lblMealType.text = boardingDetails[i]
            }
        }
        
        if let nonRefundable = dict[WSResponseParams.WS_RESP_PARAM_NON_REFUNDABLE] as? Bool {
            if nonRefundable {
                cell.lblRefundable.text = Strings.NON_REFUNDABLE
            } else {
                cell.lblRefundable.text = Strings.REFUNDABLE
            }
        }
        
        if let rooms = dict[WSRequestParams.WS_REQS_PARAM_ROOMS] as? [[String: AnyObject]] {
            for i in 0..<rooms.count {
                let newDict = rooms[i]
                
                if let roomDescription = newDict[WSResponseParams.WS_RESP_PARAM_DESCRIPTION] as? String {
                    cell.lblName.text = "1 x \(roomDescription)"
                }
            }
        }
        
        return cell
    }
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
                                               WSResponseParams.WS_RESP_PARAM_LOGID: logId as AnyObject]
            WSManager.wsCallFetchHotelDetail(params, success: { (response) in
                self.setData(response)
            }, failure: { (error) in
                
            })
        } else {
            
        }
    }
    
    func setData(_ response: HotelDetail) {
        let hotelDetail: HotelDetail?
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
        if let hotelDescription = hotelDetail?.sDescription {
            lblDescription.text = hotelDescription
        }
        if let facilities = hotelDetail?.sFacilities {
            self.facilities = facilities.components(separatedBy: "; ")
            btnFacilities.setTitle("\(String(self.facilities.count)) Facilities", for: UIControl.State())
        }
        if let minRate = hotelDetail?.iMinRate {
            self.prices = minRate
            self.tableView.reloadData()
            
            let dict = minRate[0]
            if var price = dict[WSResponseParams.WS_RESP_PARAM_PRICE] as? Int {
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
                lblHotelPrice.text = "₹\(String(price))"
            }
        }
    }
}
