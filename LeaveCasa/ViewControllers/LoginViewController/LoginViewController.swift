import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblSignup: UILabel!
    
    var rememberMe = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblSignup.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(signupClicked(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - UIBUTTON ACTIONS
extension LoginViewController {
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signupClicked(_ sender: UITapGestureRecognizer) {
        let text = lblSignup.text
        let signUpRange = (text! as NSString).range(of: "Create Account")
        
        if sender.didTapAttributedTextInLabel(label: lblSignup, inRange: signUpRange) {
            if let signup = ViewControllerHelper.getViewController(ofType: .SignupViewController) as? SignupViewController {
                self.navigationController?.pushViewController(signup, animated: true)
            }
        } else {
            print("Tapped")
        }
    }
    
    @IBAction func rememberClicked(_ sender: UIButton) {
        if sender.isSelected {
            rememberMe = false
            sender.isSelected = false
        } else {
            rememberMe = true
            sender.isSelected = true
        }
    }
    
    @IBAction func loginClicked(_ SENDER: UIButton) {
        if txtEmail.text?.isEmpty ?? true || txtPassword.text?.isEmpty ?? true {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.WRONG_EMAIL_PASSWORD)
        } else {
            Helper.showLoader(onVC: self, message: Alert.LOADING)
            loginUser()
        }
    }
    
    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
        
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else {
            txtPassword.resignFirstResponder()
        }
        return true
    }
}

// MARK: - API CALL
extension LoginViewController {
    func loginUser() {
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_EMAIL: txtEmail.text as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_PASSWORD: txtPassword.text as AnyObject]
            WSManager.wsCallLogin(params, rememberMe, completion: { (isSuccess, message) in
                if isSuccess {
                    Helper.hideLoader(onVC: self)
                    if let vc = ViewControllerHelper.getViewController(ofType: .TabBarViewController) as? TabBarViewController {
                        vc.modalPresentationStyle = .overFullScreen
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
