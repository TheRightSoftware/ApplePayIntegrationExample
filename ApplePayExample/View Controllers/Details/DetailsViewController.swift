//
//  DetailsViewController.swift
//  ApplePayExample
//
//  Created by Farrukh Javeid on 07/05/2019.
//  Copyright © 2019 The Right Software. All rights reserved.
//

import UIKit
import PassKit
import Stripe
import Alamofire

class DetailsViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var fruitNameLabel: UILabel!
    @IBOutlet weak var fruitPriceLabel: UILabel!
    @IBOutlet weak var paymentButton: PKPaymentButton!
    
    //MARK:- Properties
    var selectedFruit: Fruit!
    fileprivate let paymentURL: String = "http://localhost:8888/Stripe_Test/stripe_api.php/"

    //MARK:- UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //loading the content
        loadContent()
    }
    
    //MARK:- GUI Events
    @objc fileprivate func applePayButtonTapped(sender: UIButton) {
    
        let paymentNetworks:[PKPaymentNetwork] = [.amex,.masterCard,.visa]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            
            request.merchantIdentifier = "merchant.com.therightsw.applepay"
            request.countryCode = "US"
            request.currencyCode = "USD"
            request.supportedNetworks = paymentNetworks
            request.requiredShippingContactFields = [.name, .postalAddress]
            request.merchantCapabilities = .capability3DS
            
            let fruit = PKPaymentSummaryItem(label: selectedFruit.name, amount: NSDecimalNumber(decimal:Decimal(selectedFruit.price)), type: .final)
            let shipping = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(decimal:1.00), type: .final)
            let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(decimal:1.00), type: .final)
            let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(decimal:2.00 + Decimal(selectedFruit.price)), type: .final)
            request.paymentSummaryItems = [fruit, shipping, tax, total]
            
            let authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            
            if let viewController = authorizationViewController {
                viewController.delegate = self
                
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Helper Methods
    fileprivate func loadContent() {
        
        //Fruit
        fruitImageView.kf.setImage(with: URL(string: selectedFruit.image))
        fruitNameLabel.text = selectedFruit.name
        fruitPriceLabel.text = String(format: "$ %d", selectedFruit.price)
        
        //payment button
        paymentButton.addTarget(self, action: #selector(applePayButtonTapped(sender:)), for: .touchUpInside)
        paymentButton.isEnabled = Stripe.deviceSupportsApplePay()
    }
    
    //MARK:- PKPayment Authorization Controller Delegate
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {


        STPAPIClient.shared().createToken(with: payment) { (stripeToken, error) in
            guard error == nil, let stripeToken = stripeToken else {
                print(error!)
                return
            }
            
            Alamofire.request(self.paymentURL, method: .post, parameters: ["stripeToken": stripeToken.tokenId, "amount": self.selectedFruit.price * 100],encoding: JSONEncoding.default, headers: nil).responseString {
                response in
                switch response.result {
                case .success:
                    print("Success")
                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))

                    break
                case .failure(let error):
                    
                    print("Failure")
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))

                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // Dismiss the Apple Pay UI
        dismiss(animated: true, completion: nil)
    }
}
