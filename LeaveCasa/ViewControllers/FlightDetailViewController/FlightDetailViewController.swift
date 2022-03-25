//
//  FlightDetailViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 24/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class FlightDetailViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblFlightImage: UIImageView!
    @IBOutlet weak var lblFlightName: UILabel!
    @IBOutlet weak var lblFlightTime: UILabel!
    @IBOutlet weak var lblFlightType: UILabel!
    
    var jsonResponse = [[String: AnyObject]]()
    var numberOfAdults = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setLeftbarButton()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.tableView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] {
            if let newSize = newValue as? CGSize {
                if (object as? UITableView) != nil {
                  //  self.tableViewHeightConstraint.constant = newSize.height
                }
                
            }
        }
        
    }
    
    func setLeftbarButton() {
        self.title = " "
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    
    private func setupData() {}
    
}

// MARK: - UIBUTTON ACTIONS
extension FlightDetailViewController {
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBookNowAction(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightBookingViewController) as? FlightBookingViewController {
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITABLEVIEW METHODS
extension FlightDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1//self.jsonResponse.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FlightDetailCell, for: indexPath) as! FlightDetailCell

       // let dict = jsonResponse[indexPath.row]

        return cell
    }
}


// MARK: - API CALL
extension FlightDetailViewController {
    
    
}

