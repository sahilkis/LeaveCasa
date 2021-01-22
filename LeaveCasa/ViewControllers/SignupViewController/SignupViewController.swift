//
//  SignupViewController.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 08/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    
    var acceptTerms = true
    var validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblLogin.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(loginClicked(_:))))
        lblTerms.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(loginClicked(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObserver()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { (notification) in
            self.keyboardWillShow(notification: notification)
        })
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { (notification) in
            self.keyboardWillHide(notification: notification)
        })
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
}

// MARK: - UIBUTTON ACTIONS
extension SignupViewController {
    @objc func termsClicked(_ sender: UITapGestureRecognizer) {
        let text = lblTerms.text
        let range = (text! as NSString).range(of: "Terms & Conditions")
        if sender.didTapAttributedTextInLabel(label: lblTerms, inRange: range) {
            if let url = URL.init(string: WebService.termsAndConditions) {
                UIApplication.shared.open(url)
            }
        } else {
            print("Tapped")
        }
    }
    
    @objc func loginClicked(_ sender: UITapGestureRecognizer) {
        let text = lblLogin.text
        let loginRange = (text! as NSString).range(of: "Login")
        
        if sender.didTapAttributedTextInLabel(label: lblLogin, inRange: loginRange) {
            self.navigationController?.popViewController(animated: true)
        } else {
            print("Tapped")
        }
    }
    
    @IBAction func acceptTerms(_ sender: UIButton) {
        if sender.isSelected {
            acceptTerms = false
            sender.isSelected = false
        } else {
            acceptTerms = true
            sender.isSelected = true
        }
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
        if txtName.text?.isEmpty ?? true || txtEmail.text?.isEmpty ?? true || txtContactNumber.text?.isEmpty ?? true || txtPassword.text?.isEmpty ?? true || txtConfirmPassword.text?.isEmpty ?? true {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.ALL_FIELDS_REQUIRED)
        } else if !validator.isValid(email: txtEmail.trimmedText) {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.WRONG_EMAIL_FORMAT)
        } else if !validator.isValidPassword(txtPassword.trimmedText) {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.PASSWORD_CHECK)
        } else if txtPassword.text != txtConfirmPassword.text {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.PASSWORD_NOT_MATCH)
        } else if !acceptTerms {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.ACCEPT_TERMS)
        } else {
            Helper.showLoader(onVC: self, message: Alert.LOADING)
            signupUser()
        }
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

// MARK: - API CALL
extension SignupViewController {
    func signupUser() {
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_NAME: txtName.text as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_EMAIL: txtEmail.text as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_MOBILE: txtContactNumber.text as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_PASSWORD: txtPassword.text as AnyObject]
            WSManager.wsCallSignup(params, completion: { (isSuccess, message) in
                if isSuccess {
                    Helper.hideLoader(onVC: self)
                    if let vc = ViewControllerHelper.getViewController(ofType: .SWRevealViewController) as? SWRevealViewController {
                        self.present(vc, animated: true, completion: nil)
                    }
                } else {
                    Helper.hideLoader(onVC: self)
                    Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: message)
                }
            })
        } else {
            Helper.hideLoader(onVC: self)
        }
    }
}
