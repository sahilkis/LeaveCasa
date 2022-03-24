import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var signupViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.signupViewHeightConstraint.priority = .defaultLow
            self.signupViewHeightConstraint.constant = 0
        }

        setLeftbarButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setClearNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // setNavigationBar()
    }
    
    func setClearNavigationBar() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithTransparentBackground()
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_18 ?? UIFont.systemFont(ofSize: 18)]
            navBarAppearance.backgroundColor = UIColor.clear
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        else {
            let navigationBar = self.navigationController?.navigationBar
            navigationBar?.setBackgroundImage(UIImage(), for: .default)
            navigationBar?.shadowImage = UIImage()
            navigationBar?.isTranslucent = true
            navigationBar?.backgroundColor = UIColor.clear
            navigationBar?.tintColor = UIColor.white
        }
    }
    
    func setNavigationBar() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_18 ?? UIFont.systemFont(ofSize: 18)]
            navBarAppearance.backgroundColor = LeaveCasaColors.BLUE_COLOR
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            let navigationBar = self.navigationController?.navigationBar
            navigationBar?.barTintColor = LeaveCasaColors.BLUE_COLOR
            navigationBar?.shadowImage = UIImage()
            navigationBar?.isTranslucent = false
            navigationBar?.isOpaque = true
            navigationBar?.tintColor = UIColor.white
        }
    }
}

// MARK: - SWREVEALVIEWCONTROLLER DELEGATE
extension HomeViewController: SWRevealViewControllerDelegate {
    func setLeftbarButton() {
        self.title = "Home"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let revealController = self.revealViewController()
        revealController?.panGestureRecognizer().isEnabled = true
        revealController?.tapGestureRecognizer()?.isEnabled = true
        revealController?.delegate = self
        
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_menu"), style: .plain, target: revealController, action: #selector(SWRevealViewController.revealToggle(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == .right {
            self.view.isUserInteractionEnabled = false
        } else {
            self.view.isUserInteractionEnabled = true
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
    
    @IBAction func ToursClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func transfersClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func knowMoreClicked(_ sender: UIButton) {
        
    }
}
