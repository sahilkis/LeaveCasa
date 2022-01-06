import UIKit

class MainViewController: UIViewController {

    var _settings: SettingsManager?
    
    var settings: SettingsManagerProtocol?
    {
        if let _ = WSManager._settings {
        }
        else {
            WSManager._settings = SettingsManager()
        }

        return WSManager._settings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkUserStatus()
    }
    
    func checkUserStatus() {
        if self.settings?.rememberMe ?? false {
            if let vc = ViewControllerHelper.getViewController(ofType: .SWRevealViewController) as? SWRevealViewController {
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension MainViewController {
    @IBAction func signupClicked(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .SignupViewController) as? SignupViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func signinClicked(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .LoginViewController) as? LoginViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func skipClicked(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .SWRevealViewController) as? SWRevealViewController {
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
