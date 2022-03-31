//
//  FlightFareRulesViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 31/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class FlightFareRulesViewController: UIViewController {
    
    @IBOutlet weak var lblText: UILabel!
    
    var flights = Flight()
    var logId = 0
    var tokenId = ""
    var traceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLeftbarButton()
        setData()
        
        searchFlightFare()
    }
    
    func setLeftbarButton() {
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setData() {
        let string = "--"
        
        self.lblText.text = string
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FlightFareRulesViewController {
    
       
       func searchFlightFare() {
           
           if WSManager.isConnectedToInternet() {
               var params: [String: AnyObject] = [
                WSResponseParams.WS_RESP_PARAM_TRACE_ID : self.traceId as AnyObject,
                WSResponseParams.WS_RESP_PARAM_TOKEN : self.tokenId as AnyObject,
                WSResponseParams.WS_RESP_PARAM_LOGID : self.logId as AnyObject,
                WSResponseParams.WS_RESP_PARAM_RESULTS_INDEX : self.flights.sResultIndex as AnyObject
               ]
               
               params[WSResponseParams.WS_RESP_PARAM_LOGID] = 1480 as AnyObject //TODO: Pending
               
               DispatchQueue.main.async {
                   
                   Helper.showLoader(onVC: self, message: Alert.LOADING)
                   WSManager.wsCallFetchFlightFareDetails(params, success: { (result) in
                       Helper.hideLoader(onVC: self)
                       
                       if let fareRules = result[WSResponseParams.WS_RESP_PARAM_FARES_RULES_CAP] as? [[String:AnyObject]] {
                           for fareRule in fareRules {
                               if let fareRuleDetails = fareRule[WSResponseParams.WS_RESP_PARAM_FARES_RULE_DETAIL] as? String {
                                   self.lblText.text = fareRuleDetails
                                   
                                   if fareRuleDetails.contains("<") || fareRuleDetails.contains(">") {
                                       self.lblText.attributedText = fareRuleDetails.htmlToAttributedString
                                   }
                               }
                           }
                       }
                       
                       
                   }, failure: { (error) in
                       Helper.hideLoader(onVC: self)
                       Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
                   })
               }
           } else {
               Helper.hideLoader(onVC: self)
               Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                   Helper.showLoader(onVC: self, message: Alert.LOADING)
                   // self.searchFlight()
               })
           }
       }
}
