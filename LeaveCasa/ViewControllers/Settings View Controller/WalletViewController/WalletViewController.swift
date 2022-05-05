//
//  WalletViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 05/05/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet weak var lblWalletBalance: UILabel!
    
    var walletBalance = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLeftbarButton()
        fetchWalletBalance()
        setupData()
    }
    
    func setLeftbarButton() {
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setupData() {
        self.lblWalletBalance.text = "₹\(self.walletBalance)"
        
    }
    
}

// MARK: - UIBUTTON ACTIONS
extension WalletViewController {
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - API CALL
extension WalletViewController {
    func fetchWalletBalance() {
        
        Helper.showLoader(onVC: self, message: "")
        WSManager.wsCallFetchWalletBalence { (isSuccess, balance, message) in
            Helper.hideLoader(onVC: self)
            if isSuccess {
                self.walletBalance = balance
                self.lblWalletBalance.text = "₹\(balance)"
            }
        }
    }
}

