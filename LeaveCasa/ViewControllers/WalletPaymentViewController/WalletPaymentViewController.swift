import UIKit

class WalletPaymentViewController: UIViewController {
    
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var btnUseWalletBalance: UIButton!
    @IBOutlet weak var lblTotalAmountPayable: UILabel!
    
    var totalPayable = Int()
    var walletBalance = Double()
    var params = [String:AnyObject]()
    
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
            
            WSManager.wsCallFinalBooking(params, completion: { (isSuccess, balance, message) in
                Helper.hideLoader(onVC: self)
                if isSuccess {
                    
                }
                else {
                    Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: "Please try again")
                }
            })
        }
        else {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.NO_INTERNET_CONNECTION)
            
        }
    }
}
