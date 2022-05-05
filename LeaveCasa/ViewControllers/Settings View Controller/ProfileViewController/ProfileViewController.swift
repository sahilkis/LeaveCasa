//
//  ProfileViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 04/05/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import DropDown
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewDob: UIView!
    @IBOutlet weak var viewCity: UIView!
    
    var isEditable: Bool = false
    var loggedInUser = User()
    var dob = Date()
    var image: UIImage?
    var dropDown = DropDown()
    var genders = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loggedInUser = SettingsManager().loggedInUser
        
        self.txtName.delegate = self
        self.txtEmail.delegate = self
        self.txtPhone.delegate = self
        self.txtGender.delegate = self
        self.txtDob.delegate = self
        self.txtCity.delegate = self
        
        setLeftbarButton()
        setUpData()
        self.getUser()
    }
    
    func setLeftbarButton() {
        self.title = " "
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setRightbarButton() {
        let rightBarButton = UIBarButtonItem.init(title: Strings.SAVE, style: .done, target: self, action: #selector(rightBarButton(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setUpData() {
        
        self.txtName.text = loggedInUser.sName
        self.txtEmail.text = loggedInUser.sEmail
        self.txtPhone.text = loggedInUser.sPhone
        self.txtGender.text = loggedInUser.sGender
        self.txtDob.text = loggedInUser.sDob
        self.txtCity.text = loggedInUser.sCity
        
        if !(loggedInUser.sProfilePath.isEmpty || loggedInUser.sProfilePic.isEmpty) {
            
            let imageUrl = loggedInUser.sProfilePath + loggedInUser.sProfilePic

                        if let imageStr = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                            if let url = URL(string: imageStr) {
                                self.profilePic.sd_setImage(with: url, completed: nil)
                            }
                        }
                    }
        
        if !isEditable
        {
            self.profilePicButton.isHidden = true
            self.txtName.isEnabled = false
            self.txtEmail.isEnabled = false
            self.txtPhone.isEnabled = false
            self.txtGender.isEnabled = false
            self.txtDob.isEnabled = false
            self.txtCity.isEnabled = false
            
            self.viewName.isHidden = (self.txtName.text?.isEmpty ?? false) ? true : false
            self.viewEmail.isHidden = (self.txtEmail.text?.isEmpty ?? false) ? true : false
            self.viewPhone.isHidden = (self.txtPhone.text?.isEmpty ?? false) ? true : false
            self.viewGender.isHidden = (self.txtGender.text?.isEmpty ?? false) ? true : false
            self.viewDob.isHidden = (self.txtDob.text?.isEmpty ?? false) ? true : false
            self.viewCity.isHidden = (self.txtCity.text?.isEmpty ?? false) ? true : false
            
        }
        else {
            setRightbarButton()
        }
        
        //TODO: Hiding some TFs for now, will remove below 3 lines later
        self.viewGender.isHidden = true
        self.viewDob.isHidden = true
        self.viewCity.isHidden = true
    }
    
    func openDateCalendar() {
        if let calendar = ViewControllerHelper.getViewController(ofType: .WWCalendarTimeSelector) as? WWCalendarTimeSelector {
            calendar.delegate = self
            calendar.optionCurrentDate = dob
            calendar.optionStyles.showDateMonth(true)
            calendar.optionStyles.showMonth(false)
            calendar.optionStyles.showYear(true)
            calendar.optionStyles.showTime(false)
            calendar.optionButtonShowCancel = true
            present(calendar, animated: true, completion: nil)
        }
    }
    
    func openDropDown(_ textfield: UITextField,_ array: [String]) {
        dropDown.show()
        dropDown.textColor = UIColor.black
        dropDown.textFont = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        dropDown.backgroundColor = UIColor.white
        dropDown.anchorView = textfield
        dropDown.dataSource = array
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textfield.text = item
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension ProfileViewController {
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        self.updateProfile()
    }
    
    @IBAction func editPicButton(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            
            self.image = image
            self.profilePic.image = self.image
        }
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtName || textField == self.txtEmail || textField == self.txtPhone {
            return true
        } else if textField == self.txtDob {
            openDateCalendar()
            return false
        } else if textField == self.txtGender {
            openDropDown(textField, genders)
            return false
        } else if textField == self.txtCity {
            
            return true
        }
        else {
            return false
        }
    }
}

// MARK: - WWCALENDARTIMESELECTOR DELEGATE
extension ProfileViewController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        txtDob.text = Helper.convertDate(date)
        dob = date
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if date > Date() {
            return false
        } else {
            return true
        }
    }
}

extension ProfileViewController {
    func updateProfile() {
        if image != nil
        {
            uploadProfilePic()
        } else {
            updateUserProfile()
        }
    }
    
    func updateUserProfile() {
        if WSManager.isConnectedToInternet() {
            self.view.resignFirstResponder()
            
            let name = self.txtName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let email = self.txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let phone = self.txtPhone.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let gender = self.txtGender.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let dob = self.txtDob.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let city = self.txtCity.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            if name?.isEmpty ?? true || email?.isEmpty ?? true {
                Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.ALL_FIELDS_REQUIRED)
                
                return
            } else if !Validator().isValid(email: txtEmail.trimmedText) {
                Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.WRONG_EMAIL_FORMAT)
                
                return
            }
            
            var params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_NAME: name as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_EMAIL: email as AnyObject]
            
            if !(phone?.isEmpty ?? false) {
                params[WSRequestParams.WS_REQS_PARAM_MOBILE] = phone as AnyObject
            }
            if !(gender?.isEmpty ?? false) {
                params[WSRequestParams.WS_REQS_PARAM_GENDER] = gender as AnyObject
            }
            if !(dob?.isEmpty ?? false) {
                params[WSResponseParams.WS_RESP_PARAM_DOB] = dob as AnyObject
            }
            if !(city?.isEmpty ?? false) {
                params[WSResponseParams.WS_RESP_PARAM_CITY] = city as AnyObject
            }
            Helper.showLoader(onVC: self, message: Alert.LOADING)
            
            WSManager.wsCallUpdateProfile(params, completion: { isSuccess, response, message in
                if isSuccess {
                    Helper.hideLoader(onVC: self)
                    
                    self.getUser()
                    Helper.showOKAlert(onVC: self, title: Alert.SUCCESS, message: response ?? "")
                    
                } else {
                    Helper.hideLoader(onVC: self)
                    Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: message)
                }
            })
        } else {
            Helper.hideLoader(onVC: self)
        }
    }
    
    
    func uploadProfilePic() {
        if WSManager.isConnectedToInternet() {
            self.view.resignFirstResponder()
            
            let params: [String: String] = [:]
            
            Helper.showLoader(onVC: self, message: Alert.LOADING)
            
            WSManager.wsCallUploadImage(media: image ?? UIImage(), params: params, fileName: "image", completion: { isSuccess, response, message in
                if isSuccess {
                    Helper.hideLoader(onVC: self)
                    
                    self.updateUserProfile()
                } else {
                    Helper.hideLoader(onVC: self)
                    Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: message)
                }
            })
        } else {
            Helper.hideLoader(onVC: self)
        }
    }
    
    func getUser() {
        WSManager.wsCallFetchCustomerId { isSuccess, response, message in
            self.loggedInUser = SettingsManager().loggedInUser
            
            self.setUpData()
        }
    }
}
