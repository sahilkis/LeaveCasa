import UIKit
import Razorpay

enum ScreenFrom {
    case bus
    case flight
    case hotel
}
class WalletPaymentViewController: UIViewController {
    
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var btnUseWalletBalance: UIButton!
    @IBOutlet weak var lblTotalAmountPayable: UILabel!
    
    var totalPayable = Double()
    var walletBalance = Double()
    var walletReducinigValue = Double()
    var bookingType = ""
    var params = [String:AnyObject]()
    var screenFrom = ScreenFrom.hotel
    
    typealias Razorpay = RazorpayCheckout
    var razorpay: RazorpayCheckout!
    
    internal func showPaymentForm(currency : String, amount: Double, name: String, description : String, contact: String, email: String ){
        let options: [String:Any] = [
                    "amount": "\(amount * 100)", //This is in currency subunits. 100 = 100 paise= INR 1.
                    "currency": "INR",//We support more that 92 international currencies.
//                    "description": description,
//                    "name": name,
//                    "prefill": [
//                        "contact": contact,
//                        "email": email
//                    ],
                    "theme": [
                        "color": "#FF2D55"
                    ]
                ]
        razorpay.open(options)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        razorpay = RazorpayCheckout.initWithKey("rzp_test_Qrm4UPEWl3YvrG", andDelegate: self)
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
        
        var amount = totalPayable
        
        if btnUseWalletBalance.isSelected {
            if walletBalance > totalPayable
            {
                walletReducinigValue = totalPayable
                self.finalBooking()
                return
                // Razor not required
            } else if walletBalance < totalPayable
            {
                amount = totalPayable - walletBalance
                walletReducinigValue = walletBalance
            }
        }
        
        self.showPaymentForm(currency: "INR", amount: amount, name: "", description: "", contact: "", email: "")
    }
}

// MARK: - API CALL
extension WalletPaymentViewController {
    func fetchWalletBalance() {

        Helper.showLoader(onVC: self, message: "")
        WSManager.wsCallFetchWalletBalence { (isSuccess, balance, message) in
            Helper.hideLoader(onVC: self)
            if isSuccess {
                self.walletBalance = balance
                self.lblWalletBalance.text = "₹\(balance)"
                self.walletReducinigValue = 0
            }
        }
    }
    
    func reduceWalletBalance(_ byValue: Double, _ bookingId: String) {

        Helper.showLoader(onVC: self, message: "")
        
        let params: [String: AnyObject] = [
            "type": bookingType as AnyObject,
            "booking_id": bookingId as AnyObject,
            "credited": byValue as AnyObject
        ]

        
        WSManager.wsCallDebitWalletBalance(params) { (isSuccess, message) in
            Helper.hideLoader(onVC: self)
            if isSuccess {
                Helper.showOKAlertWithCompletion(onVC: self, title: Alert.SUCCESS, message: "Your booking is completed with booking ID: \(bookingId)", btnOkTitle: Alert.OK) {
                    
                    self.backToHome()
                }
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
            } else if screenFrom == .flight {
                
                DispatchQueue.main.async {
                    
                    Helper.showLoader(onVC: self, message: Alert.LOADING)
                    WSManager.wsCallFlightTicket(params, success: { (result) in
                        Helper.hideLoader(onVC: self)
                        
                        if let response = result[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
                            if let bookingId = response[WSResponseParams.WS_RESP_PARAM_BOOKING_ID] as? Int, let pnr = response[WSResponseParams.WS_RESP_PARAM_PNR] as? String  {
                                self.reduceWalletBalance(self.walletReducinigValue, "\(bookingId)")
                            }
                        }
                        else if let error = result[WSResponseParams.WS_RESP_PARAM_ERROR] as? [String:AnyObject], let errorMessage = error[WSResponseParams.WS_RESP_PARAM_ERROR_MESSAGE] as? String  {
                            Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: errorMessage)
                        }
                        
                    }, failure: { (error) in
                        Helper.hideLoader(onVC: self)
                        Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
                    })
                }
                
                return
            }
            
            WSManager.wsCallFinalBooking(url, params, completion: { (isSuccess, response, message) in
                Helper.hideLoader(onVC: self)
                if isSuccess {
                    
//                    if let tinNumber = response?[WSResponseParams.WS_RESP_PARAM_TIN] as? String {
//
//
//                    }
                    self.reduceWalletBalance(self.walletReducinigValue, "")
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

extension WalletPaymentViewController : RazorpayPaymentCompletionProtocol {
    func onPaymentError(_ code: Int32, description str: String) {
        print("error: ", code, str)
        
        Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: str)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
        Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.PAYMENT_SUCCESS)

        self.finalBooking()
    }
}

extension WalletPaymentViewController: RazorpayPaymentCompletionProtocolWithData {
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("error: ", code)
        Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: str)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("success: ", payment_id)
        
        if let razorpay_payment_id = response?["razorpay_payment_id"] as? String, let razorpay_order_id = response?["razorpay_order_id"] as? String, let razorpay_signature = response?["razorpay_signature"] as? String {
            print("razorpay_payment_id  : \(razorpay_payment_id)")
            print("razorpay_order_id  : \(razorpay_order_id)")
            print("razorpay_signature  : \(razorpay_signature)")
        }
        
        Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.PAYMENT_SUCCESS)
        
        self.finalBooking()
          
    }
}
