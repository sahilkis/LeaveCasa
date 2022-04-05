import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCustomerId()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    func setNavigationBar() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithTransparentBackground()
            navBarAppearance.backgroundColor = LeaveCasaColors.NAVIGATION_COLOR
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        else {
            let navigationBar = self.navigationController?.navigationBar
            navigationBar?.setBackgroundImage(UIImage(), for: .default)
            navigationBar?.shadowImage = UIImage()
            navigationBar?.isTranslucent = true
            navigationBar?.backgroundColor = LeaveCasaColors.NAVIGATION_COLOR
            navigationBar?.tintColor = UIColor.black
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension HomeViewController {
    @IBAction func flightsClicked(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .SearchFlightViewController) as? SearchFlightViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func hotelsClicked(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .SearchHotelViewController) as? SearchHotelViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func busClicked(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .SearchBusViewController) as? SearchBusViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension HomeViewController {
    func getCustomerId() {
        if (WSManager.settings?.customerId.isEmpty ?? true){
            WSManager.wsCallFetchCustomerId { isSuccess, response, message in
                
            }
        }
    }
}
