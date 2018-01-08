//
//  MoneyUnlimitedViewController.swift
//  Crypto
//
//  Created by Speedy Singh on 12/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import FacebookCore

class MoneyUnlimitedViewController: UIViewController {
    @IBOutlet weak var moneyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var hyperlinkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(onClicLabel(sender:)))
        hyperlinkLabel.isUserInteractionEnabled = true
        hyperlinkLabel.addGestureRecognizer(tap)
    }
    
    @objc func onClicLabel(sender:UITapGestureRecognizer) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        if SwifterSwift.screenHeight > 568 {
            moneyTopConstraint.constant = 40
        } else {
            moneyTopConstraint.constant = -40
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }

    @IBAction func okayButtonAction(_ sender: Any) {
        SwiftyStoreKit.retrieveProductsInfo(["11212017"]) { result in
            if let product = result.retrievedProducts.first {
                AppEventsLogger.log("IAP prompt shown")
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                //                    return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
        self.perform(#selector(inAppPurchase), with: nil, afterDelay: 2.0)
    }
    
    @objc func inAppPurchase() {
        SwiftyStoreKit.purchaseProduct("11212017", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                }
            }
        }
    }
  }

