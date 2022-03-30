import UIKit

class HotelCancellationPolicyViewController: UIViewController {

    @IBOutlet weak var lblCancellationPolicy: UILabel!
    
    var hotelCancellationPolicy = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftbarButton()
        setData()
    }

    func setLeftbarButton() {
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setData() {
        var cancellationPolicyString = ""
        if let cancelByDate = hotelCancellationPolicy[WSResponseParams.WS_RESP_PARAM_CANCEL_BY_DATE] as? String {
            if let details = hotelCancellationPolicy[WSResponseParams.WS_RESP_PARAM_DETAILS] as? [[String: AnyObject]] {
                if let from = details[0][WSResponseParams.WS_RESP_PARAM_FROM] as? String {
                    if let noShowFee = hotelCancellationPolicy[WSResponseParams.WS_RESP_PARAM_NO_SHOW_FEE] as? [String: AnyObject] {
                        if let amountType = noShowFee[WSResponseParams.WS_RESP_PARAM_AMOUNT_TYPE] as? String {
                            if amountType == "value" {
                                if let flatFee = noShowFee[WSResponseParams.WS_RESP_PARAM_FLAT_FEE] as? Int {
                                    cancellationPolicyString = "● Cancellation charges starts from \(Helper.convertStoredDate(from, "dd MMM, yyyy HH:mm:ss")) \n\n● This booking is not under cancellation and you don't have to pay charges from till date.\n\n● Free cancellation till \(Helper.convertStoredDate(cancelByDate, "dd MMM, yyyy HH:mm:ss"))\n\n● Cancellation charges for no show fee will be \(flatFee) INR"
                                }
                            }
                            else {
                                if let percentage = noShowFee[WSResponseParams.WS_RESP_PARAM_PERCENT] as? Int {
                                    cancellationPolicyString = "● Cancellation charges starts from \(Helper.convertStoredDate(from, "dd MMM, yyyy HH:mm:ss")) \n\n● This booking is not under cancellation and you don't have to pay charges from till date.\n\n● Free cancellation till \(Helper.convertStoredDate(cancelByDate, "dd MMM, yyyy HH:mm:ss"))\n\n● Cancellation charges for no show fee will be \(percentage)%"
                                }
                            }
                        }
                    }
                    
                    self.lblCancellationPolicy.text = cancellationPolicyString
                }
            }
        }
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
