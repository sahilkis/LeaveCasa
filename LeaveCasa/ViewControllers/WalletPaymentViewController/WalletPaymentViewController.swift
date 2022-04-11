import UIKit

enum ScreenFrom {
    case bus
    case flight
    case hotel
}
class WalletPaymentViewController: UIViewController {
    
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var btnUseWalletBalance: UIButton!
    @IBOutlet weak var lblTotalAmountPayable: UILabel!
    
    var totalPayable = Int()
    var walletBalance = Double()
    var params = [String:AnyObject]()
    var screenFrom = ScreenFrom.hotel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLeftbarButton()
        fetchWalletBalance()
        setupData()
    }
    
    func setLeftbarButton() {
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setupData() {
        
    }
    
    func backToHome() {
        let viewControllers: [UIViewController] = self.navigationController?.viewControllers ?? []
        for aViewController in viewControllers {
            if aViewController is HomeViewController {
                self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension WalletPaymentViewController {
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func useWalletBalanceClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
    }
    
    @IBAction func proceedToPaymentClicked(_ sender: UIButton) {
        finalBooking()
    }
}

// MARK: - API CALL
extension WalletPaymentViewController {
    func fetchWalletBalance() {
        WSManager.wsCallFetchWalletBalence { (isSuccess, balance, message) in
            if isSuccess {
                self.walletBalance = balance
                self.lblWalletBalance.text = "₹\(balance)"
            }
        }
    }
    
    func finalBooking() {
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = params
            Helper.showLoader(onVC: self, message: "")
            
            var url = WebService.finalBooking
            
            if screenFrom == .bus
            {
                url = WebService.busTicketFinal
            }
            
            WSManager.wsCallFinalBooking(url, params, completion: { (isSuccess, response, message) in
                Helper.hideLoader(onVC: self)
                if isSuccess {
                    
                    if let tinNumber = response?[WSResponseParams.WS_RESP_PARAM_TIN] as? String {
                        
                        Helper.showOKAlertWithCompletion(onVC: self, title: Alert.SUCCESS, message: "Your seat is booked for tin number: \(tinNumber)", btnOkTitle: Alert.OK) {
                            
                            self.backToHome()
                        }
                    }
                }
                else {
                    Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: message)
                }
            })
        }
        else {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.NO_INTERNET_CONNECTION)
            
        }
    }
}
