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
        inAppPurchaseAlert()
    }
}
