//
//  MainViewController.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 08/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
