//
//  FacilitiesViewController.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 25/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FacilitiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var facilities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftbarButton()
    }

    func setLeftbarButton() {
        self.title = Strings.FACILITIES
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITABLEVIEW METHODS
extension FacilitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FacilitiesCell, for: indexPath)
        
        cell.textLabel?.text = facilities[indexPath.row].capitalized
        
        return cell
    }
}
