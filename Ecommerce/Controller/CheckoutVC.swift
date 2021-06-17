//
//  CheckoutVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/13.
//

import UIKit
import Stripe
import PassKit
import FirebaseFunctions

class CheckoutVC: UIViewController, CartItemCellDelegate {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Variables
    var paymentContext: STPPaymentContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        updatePaymentInfo()
        setUpStripeConfig()
    }
    
    fileprivate func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.CartItemCell, bundle: nil), forCellReuseIdentifier: Identifiers.CartItemCell)
    }
    
    fileprivate func updatePaymentInfo() {
        subtotalLabel.text = StripeCart.subtotal.penniesToFormattedCurrency()
        processingLabel.text = StripeCart.processingFees.penniesToFormattedCurrency()
        shippingCostLabel.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalLabel.text = StripeCart.total.penniesToFormattedCurrency()
    }
    
    func setUpStripeConfig() {
        let config = STPPaymentConfiguration.shared
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress]
        
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .defaultTheme)
        
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    func removeItem(product: Product) {
        guard let index = StripeCart.cartItems.firstIndex(of: product) else {
            debugPrint("Cart item \(product.name) could not be removed since it cannot be found in the cart items array.")
            return
        }
        StripeCart.removeItemFromCart(item: product)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        updatePaymentInfo()
        
        // Update the amount the user is to be charged.
        paymentContext.paymentAmount = StripeCart.total
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        paymentContext.requestPayment()
        activityIndicator.startAnimating()
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
        paymentContext.pushPaymentOptionsViewController()
    }
    
    @IBAction func shippingMethodClicked(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartItemCell) as? CartItemCell {
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension CheckoutVC: STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        // Update the title of payment method button with selected method
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodBtn.setTitle(paymentMethod.label, for: .normal)
        } else {
            paymentMethodBtn.setTitle("Select Method", for: .normal)
        }
        
        // Updating the selected shipping method
        if let shippingMethod = paymentContext.selectedShippingMethod {
            shippingMethodBtn.setTitle(shippingMethod.label, for: .normal)
            StripeCart.shippingFees = Int(Double(truncating: shippingMethod.amount) * 100)
            updatePaymentInfo()
        } else {
            shippingMethodBtn.setTitle("Select Method", for: .normal)
        }
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.navigationController?.popViewController(animated: true)
        }
        let retry = UIAlertAction(title: "Retry", style: .default) { action in
            paymentContext.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        // Create an idempotent key using built-in UUID string variable with the dash characters being removed.
        let idempotencyKey = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let data: [String: Any] = [
            "total_amount": StripeCart.total,
            "customer_id": UserService.user.stripeId,
            "payment_method_id": paymentResult.paymentMethod?.stripeId ?? "",
            "idempotency": idempotencyKey
        ]
        
        Functions.functions().httpsCallable("createCharge").call(data) { result, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                self.presentAlert(withTitle: "Error", message: "Unable to make charge.")
                completion(.error, error)
                return
            }
            // The cloud function is executed successfully.
            StripeCart.clearCart()
            self.tableView.reloadData()
            self.updatePaymentInfo()
            completion(.success, nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        var title: String
        var message: String
        
        switch status {
        case .success:
            title = "Success!"
            message = "Thank you for your purchase."
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .userCancellation:
            return
        }
        
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3–5 days"
        upsGround.identifier = "ups_ground"
        
        let fedEx = PKShippingMethod()
        fedEx.amount = 6.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrives tomorrow"
        fedEx.identifier = "fedex"
        
        // Only a US address is accepted.
        if address.country == "US" {
            completion(.valid, nil, [upsGround, fedEx], fedEx)
        } else {
            completion(.invalid, nil, nil, nil)
        }
        
    }
    
}
