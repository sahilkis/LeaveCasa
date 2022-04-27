import UIKit

class TripsViewController: UIViewController {
    
    @IBOutlet weak var btnFlights: UIButton!
    @IBOutlet weak var underlineFlights: UIView!
    @IBOutlet weak var btnHotels: UIButton!
    @IBOutlet weak var underlineHotels: UIView!
    @IBOutlet weak var underlineBuses: UIView!
    @IBOutlet weak var btnBuses: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoBooking: UILabel!
    //    @IBOutlet weak var lblDes: UILabel!
    
    var flights = [Flight]()
    var hotels = [Hotels]()
    var buses = [Bus]()
    var selectedTab = ScreenFrom.flight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoBooking.isHidden = true
        setLeftbarButton()
        setUpTab()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTrips()
    }
    
    private func setUpTab() {
        let selectedColor = LeaveCasaColors.PINK_COLOR
        let unselectedColor = LeaveCasaColors.LIGHT_GRAY_COLOR
        let clearColor = UIColor.clear
        
        switch selectedTab
        {
        case ScreenFrom.flight:
            
            btnFlights.setTitleColor(selectedColor, for: .normal)
            underlineFlights.backgroundColor = selectedColor
            
            btnHotels.titleLabel?.textColor = unselectedColor
            btnHotels.setTitleColor(unselectedColor, for: .normal)
            underlineHotels.backgroundColor = clearColor
            
            btnBuses.titleLabel?.textColor = unselectedColor
            btnBuses.setTitleColor(unselectedColor, for: .normal)
            underlineBuses.backgroundColor = clearColor
            break
            
        case ScreenFrom.hotel:
            
            btnFlights.titleLabel?.textColor = unselectedColor
            btnFlights.setTitleColor(unselectedColor, for: .normal)
            underlineFlights.backgroundColor = clearColor
            
            btnHotels.setTitleColor(selectedColor, for: .normal)
            underlineHotels.backgroundColor = selectedColor
            
            btnBuses.titleLabel?.textColor = unselectedColor
            btnBuses.setTitleColor(unselectedColor, for: .normal)
            underlineBuses.backgroundColor = clearColor
            break
            
        case ScreenFrom.bus:
            btnFlights.titleLabel?.textColor = unselectedColor
            btnFlights.setTitleColor(unselectedColor, for: .normal)
            underlineFlights.backgroundColor = clearColor
            
            btnHotels.titleLabel?.textColor = unselectedColor
            btnHotels.setTitleColor(unselectedColor, for: .normal)
            underlineHotels.backgroundColor = clearColor
            
            btnBuses.setTitleColor(selectedColor, for: .normal)
            underlineBuses.backgroundColor = selectedColor
            break
        default: break
            
        }
        
        self.tableView.reloadData()
    }
    
    func setLeftbarButton() {
        self.title = Strings.MY_TRIPS
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.SIDE_MENU, style: .plain, target: self, action: #selector(leftBarButton(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
}

// MARK: - UIBUTTON ACTIONS
extension TripsViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func leftBarButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func btnFlightsAction(_ sender: UIButton) {
        selectedTab = .flight
        setUpTab()
    }
    
    @IBAction func btnHotelsAction(_ sender: UIButton) {
        selectedTab = .hotel
        setUpTab()
    }
    
    @IBAction func btnBusesAction(_ sender: UIButton) {
        selectedTab = .bus
        setUpTab()
    }
}


// MARK: - UITABLEVIEW METHODS
extension TripsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case .flight:
            self.lblNoBooking.isHidden = (flights.count > 0) ? true : false
            return flights.count
        case .hotel:
            self.lblNoBooking.isHidden = (hotels.count > 0) ? true : false
            return hotels.count
        case .bus:
            self.lblNoBooking.isHidden = (buses.count > 0) ? true : false
            return buses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.TripsCell, for: indexPath) as! TripsCell
        switch selectedTab {
        case .flight:
            
            let flight = flights[indexPath.row]
            
            cell.imgHotel.image = LeaveCasaIcons.HOME_FLIGHT
            cell.lblHotelName.text = flight.sAirlineCode
            
            
            var flightNameString = ""
            var flightDatesString = ""
            var flightClassString = ""
            
            for (flightIndex, flightSegment) in flight.sSegments.enumerated() {
            if let firstSeg = flightSegment.first {
                let sSourceCode = firstSeg.sOriginAirport.sCityCode
                let sStartTime = firstSeg.sOriginDeptTime
                
                flightNameString += "\(sSourceCode.uppercased()) - "
                flightDatesString += "\(Helper.convertStoredDate(sStartTime, "E, MMM d, yyyy")) - "
                flightClassString  += "\(AppConstants.flightTypes[(firstSeg.sCabinClass > 0 ? firstSeg.sCabinClass : 1)-1]) - "
                
                if let secondSeg = flightSegment.last, flightIndex == flight.sSegments.count - 1 {
                    let sDestinationCode = secondSeg.sDestinationAirport.sCityCode
                    
                    flightNameString += "\(sDestinationCode.uppercased())"
                    
                }
            }
            
            }
            cell.lblHotelAddress.text = flightNameString
            cell.lblDates.text = flightDatesString

            let price = flight.sPrice
            cell.lblHotelPrice.text = "₹\(String(format: "%.0f", price))"
            
        case .hotel:
            
            let hotel = hotels[indexPath.row]
            
            cell.imgHotel.image = LeaveCasaIcons.HOME_HOTEL
            cell.lblHotelAddress.text = hotel.sAddress
            cell.lblHotelName.text = hotel.sName
            
            let price = hotel.iMinRate.sPrice
            cell.lblHotelPrice.text = "₹\(String(format: "%.0f", price))"
            
        case .bus:
            
            let bus = buses[indexPath.row]
            
            cell.imgHotel.image = LeaveCasaIcons.HOME_BUS
            cell.lblHotelAddress.text = "\(bus.sSourceCode) - \(bus.sDestinationCode)"
            cell.lblHotelName.text = bus.sTravels
            
            let arrivalTime = Helper.getTimeString(time: bus.sArrivalTime)
            let departureTime = Helper.getTimeString(time: bus.sDepartureTime)
            cell.lblDates.text = "\(departureTime) - \(arrivalTime)"
            
            if let price = bus.fareDetails as? [String: AnyObject] {
                var farePrice = 0.0
                
                if let fare = price[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String {
                    farePrice = Double(fare) ?? 0
                }
                
                if let priceArray = bus.fareDetailsArray as? [[String: AnyObject]] {
                    for i in 0..<priceArray.count {
                        let dict = priceArray[i]
                        if let fare = dict[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String {
                            farePrice = Double(fare) ?? 0
                            break
                        }
                    }
                }
                
                //                if let markup = markups as? Markup {
                //                    if markup.amountBy == Strings.PERCENT {
                //                        farePrice += (farePrice * (markup.amount) / 100)
                //                    } else {
                //                        farePrice += (markup.amount)
                //                    }
                //                }
                cell.lblHotelPrice.text = "₹\(String(format: "%.0f", farePrice))"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = ViewControllerHelper.getViewController(ofType: .TripsDetailViewController) as? TripsDetailViewController {
            vc.selectedTab = self.selectedTab

            if self.selectedTab == .flight {
                vc.flight = self.flights[indexPath.row]
            } else if self.selectedTab == .hotel {
                vc.hotel = self.hotels[indexPath.row]
            } else if self.selectedTab == .bus {
                vc.bus = self.buses[indexPath.row]
            }

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - API CALL
extension TripsViewController {
    func fetchTrips() {
        if WSManager.isConnectedToInternet() {
            Helper.showLoader(onVC: self, message: "")
            WSManager.wsCallFetchTrips(success: { (hotels, buses, flights) in
                Helper.hideLoader(onVC: self)
                self.flights = flights
                self.hotels = hotels
                self.buses = buses
                
                self.tableView.reloadData()
            }, failure: { (error) in
                Helper.hideLoader(onVC: self)
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.hideLoader(onVC: self)
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                self.fetchTrips()
            })
        }
    }
}
