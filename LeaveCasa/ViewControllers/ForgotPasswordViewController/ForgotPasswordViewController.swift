//
//  ForgotPasswordViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 08/04/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtEmail: UITextField!
    
    var validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension ForgotPasswordViewController {
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendClicked(_ sender: UIButton) {
        if txtEmail.text?.isEmpty ?? true {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.ALL_FIELDS_REQUIRED)
        } else if !validator.isValid(email: txtEmail.trimmedText) {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.WRONG_EMAIL_FORMAT)
        } else {
            Helper.showLoader(onVC: self, message: Alert.LOADING)
            forgotPasswordApi()
        }
    }
    
    func backToHome() {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UITEXTFIELD DELEGATE
extension ForgotPasswordViewController: UITextFieldDelegate {
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
extension ForgotPasswordViewController {
    func forgotPasswordApi() {
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [
                WSRequestParams.WS_REQS_PARAM_EMAIL: txtEmail.text as AnyObject,
            ]
            WSManager.wsCallForgotPassword(params, completion: { (isSuccess, message) in
                if isSuccess {
                    Helper.hideLoader(onVC: self)
                    Helper.showOKAlertWithCompletion(onVC: self, title: Alert.SUCCESS, message: message, btnOkTitle: Alert.OK) {
                        //                                                self.backToHome()
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
