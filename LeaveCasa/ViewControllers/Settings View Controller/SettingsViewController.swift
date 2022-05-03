//
//  SettingsViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 21/04/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var sliderProfile: UISlider!
    @IBOutlet weak var lblProfileDesc: UILabel!
    
    struct SideMenuData
    {
        var title = String()
        var subtitle : String?
        var image : UIImage?
    }
    var array = [
        SideMenuData(title: "My Account", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_USER),
        SideMenuData(title: "Wallet", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_WALLET),
        SideMenuData(title: "Refer & Earn", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_REFER),
        SideMenuData(title: "Notifications", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_NOTIFICATION),
        SideMenuData(title: "Rate Us", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_RATE),
        SideMenuData(title: "Logout", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_USER)
    ]
    var loggedInUser = User()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loggedInUser = SettingsManager().loggedInUser
        
        setUpDate()
    }
    
    func setUpDate()  {
        self.lblName.text = self.loggedInUser.sName
        self.lblPhone.text = self.loggedInUser.sEmail
    }
    
    func logout() {
        
        Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.ALERT, message: AlertMessages.LOGOUT, btnOkTitle: Alert.LOGOUT, btnCancelTitle: Alert.CANCEL) {
            
                   SettingsManager().removeAll()
                   
                   self.dismiss(animated: true, completion: {
                       self.navigationController?.popToRootViewController(animated: true)
                   })
        }
       
    }
}

// MARK: - UIBUTTON ACTIONS
extension SettingsViewController {
    @IBAction func editProfileClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func contactUsClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func privacyPolicyClicked(_ sender: UIButton) {
        
    }
}

// MARK: - UITABLEVIEW METHODS
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.SettingsCell, for: indexPath) as! SettingsCell
        let item = array[indexPath.row]
        
        cell.lblName.text = item.title
        cell.lbldes.text = item.subtitle ?? ""
        cell.img.image = item.image ?? UIImage()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == array.count - 1 //LOGOUT
        {
            logout()
        }
    }
}
