//
//  TripsFlightDetailsCell.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 28/04/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class TripsFlightDetailsCell: UITableViewCell {
    
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFLightInfo: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblStops: UILabel!
    @IBOutlet weak var lblAirline: UILabel!
    @IBOutlet weak var lblFlightNo: UILabel!
    @IBOutlet weak var lblTerminal: UILabel!
    @IBOutlet weak var lblGate: UILabel!
    @IBOutlet weak var lblSeats: UILabel!
    
    func setUp(indexPath: IndexPath, flight: Flight) {
        
        self.lblPrice.text = "₹ \(flight.sPrice)"
        self.lblFLightInfo.text = ""
        
        self.lblFLightInfo.isHidden = true
        self.lblPrice.isHidden = true
        self.topSpace.constant = 0
        
        if indexPath.row == 0
        {
            self.lblFLightInfo.isHidden = false
            self.lblPrice.isHidden = false
            self.topSpace.constant = 16
        }
        
        if let flightSegment = flight.sSegments[indexPath.row] as? [FlightSegment]{
            if let firstSeg = flightSegment.first {
                let sSource = firstSeg.sOriginAirport.sCityName
                let sSourceCode = firstSeg.sOriginAirport.sCityCode
                let sAirlineName = firstSeg.sAirline.sAirlineName
                let sStartTime = firstSeg.sOriginDeptTime
                let sDuration = firstSeg.sDuration
                let sStopsCount = flightSegment.count - 1
                
                if let secondSeg = flightSegment.last {
                    let sEndTime = secondSeg.sDestinationArrvTime
                    let sDestination = secondSeg.sDestinationAirport.sCityName
                    let sDestinationCode = secondSeg.sDestinationAirport.sCityCode
                    let sAccDuration = secondSeg.sAccDuration == 0 ? firstSeg.sDuration : secondSeg.sAccDuration
                    
                    self.lblStartDate.text = Helper.convertStoredDate(sStartTime, "E, MMM d, yyyy")
                    self.lblEndDate.text = Helper.convertStoredDate(sEndTime, "E, MMM d, yyyy")
                    self.lblStartTime.text = Helper.convertStoredDate(sStartTime, "HH:mm")
                    self.lblEndTime.text = Helper.convertStoredDate(sEndTime, "HH:mm")
                    self.lblSource.text = "\(sSourceCode.uppercased()), \(Helper.convertStoredDate(sStartTime, "E").uppercased())"
                    self.lblDestination.text = "\(sDestinationCode.uppercased()), \(Helper.convertStoredDate(sEndTime, "E").uppercased())"
                    
                    self.lblDuration.text = Helper.getDuration(minutes: sAccDuration)
                    self.lblRoute.text = sStopsCount == 0 ? "Non-stop" : "\(sStopsCount) stop(s)"
                    self.lblAirline.text = sAirlineName
                    
                    if let startTime = Helper.getStoredDate(sStartTime) {
                        let components = Calendar.current.dateComponents([ .hour, .minute], from: Date(), to: startTime)
                        
                        let hour = components.hour ?? 0
                        let minute = components.minute ?? 0
                        
                        if hour < 5 && hour > 0 {
                            self.lblFLightInfo.text = "< \(hour) hours"
                        } else if hour < 5 && minute > 0 {
                            self.lblFLightInfo.text = "< \(minute) minutes"
                        }
                    }
                }
                self.lblFlightNo.text = firstSeg.sAirline.sFlightNumber
                self.lblTerminal.text = firstSeg.sOriginAirport.sTerminal
                
            }
            var sStops = [FlightAirport]()
            
            for i in 1..<flightSegment.count {
                sStops.append(flightSegment[i].sOriginAirport)
            }
            
            var stops = ""
            
            if sStops.count == 1
            {
                stops = sStops[0].sCityName
            } else if sStops.count > 1
            {
                stops = "\(sStops[0].sCityName) + \(sStops.count)"
            }
            
            self.lblStops.text = stops
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

