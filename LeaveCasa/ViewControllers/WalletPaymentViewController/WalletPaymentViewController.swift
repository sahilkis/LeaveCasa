import UIKit

class WalletPaymentViewController: UIViewController {

    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var btnUseWalletBalance: UIButton!
    @IBOutlet weak var lblTotalAmountPayable: UILabel!
    
    var totalPayable = Int()
    var walletBalance = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftbarButton()
        fetchWalletBalance()
    }
    
    func setLeftbarButton() {
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
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
}
