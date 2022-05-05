//
//  SettingsViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 21/04/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var sliderProfile: UISlider!
    @IBOutlet weak var lblProfileDesc: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    struct SettingsListData
    {
        var title = String()
        var subtitle : String?
        var image : UIImage?
    }
    var array = [
        SettingsListData(title: "My Account", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_USER),
        SettingsListData(title: "Wallet", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_WALLET),
        SettingsListData(title: "Refer & Earn", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_REFER),
        SettingsListData(title: "Notifications", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_NOTIFICATION),
        SettingsListData(title: "Rate Us", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_RATE),
        SettingsListData(title: "Logout", subtitle: "", image: LeaveCasaIcons.SIDE_MENU_USER)
    ]
    var loggedInUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loggedInUser = SettingsManager().loggedInUser
        
        setUpData()
    }
    
    func setUpData()  {
        self.lblName.text = self.loggedInUser.sName
        self.lblPhone.text = self.loggedInUser.sEmail
        
        if !(loggedInUser.sProfilePath.isEmpty || loggedInUser.sProfilePic.isEmpty) {
            
            let imageUrl = loggedInUser.sProfilePath + loggedInUser.sProfilePic
            
            if let imageStr = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let url = URL(string: imageStr) {
                    self.profilePic.sd_setImage(with: url, completed: nil)
                }
            }
        }
        
    }
    
    func openMyAccount() {
        
        if let vc = ViewControllerHelper.getViewController(ofType: .ProfileViewController) as? ProfileViewController {
            vc.isEditable = false
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        if let vc = ViewControllerHelper.getViewController(ofType: .ProfileViewController) as? ProfileViewController {
            vc.isEditable = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        
        switch indexPath.row {
        case 0:
            openMyAccount()
            
        case 5:
            logout()
        default:
            break
        }
        
    }
}

extension SettingsViewController {
    
    func getUser() {
        WSManager.wsCallFetchCustomerId { isSuccess, response, message in
            self.loggedInUser = SettingsManager().loggedInUser
            
            self.setUpData()
        }
    }
}
