//
//  HotelBookingViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 23/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class HotelBookingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblHotelAddress: UILabel!
    @IBOutlet weak var lblHotelPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var hotelRatingView: FloatRatingView!
//    @IBOutlet weak var lblRefundable: UILabel!

    var hotels: Hotels?
    var markups = [Markup]()
    var prices = [[String: AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib.init(nibName: CellIds.RoomsCell, bundle: nil), forCellReuseIdentifier: CellIds.RoomsCell)
        
        setupData()
        setLeftbarButton()
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
                if (object as? UITableView) != nil {
                    self.tableViewHeightConstraint.constant = newSize.height
                }
                
            }
        }
        
    }
    
    func setLeftbarButton() {
        self.title = " "
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
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
            if let nonRefundable = minRate[WSResponseParams.WS_RESP_PARAM_NON_REFUNDABLE] as? Bool {
//                if nonRefundable {
//                    self.lblRefundable.text = Strings.NON_REFUNDABLE
//                } else {
//                    self.lblRefundable.text = Strings.REFUNDABLE
//                }
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
                self.lblHotelPrice.text = "₹\(String(price))"
            }
        }
        if let rating = hotel?.iCategory {
            self.hotelRatingView.rating = Double(rating)
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension HotelBookingViewController {
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProceedToPaymentAction(_ sender: UIButton) {
//        if let vc = ViewControllerHelper.getViewController(ofType: .HotelBookingViewController) as? HotelBookingViewController {
//            vc.hotels = self.hotels
//            vc.markups = self.markups
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}


// MARK: - UITABLEVIEW METHODS
extension HotelBookingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//self.prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.BookingCell, for: indexPath) as! BookingCell
        
        
        
        return cell
    }
}

// MARK: - API CALL
extension HotelBookingViewController {
    
    
    func setResponseData(_ response: HotelDetail) {
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
//            self.facilities = facilities.components(separatedBy: "; ")
//            btnFacilities.setTitle("\(String(self.facilities.count)) Facilities", for: UIControl.State())
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

