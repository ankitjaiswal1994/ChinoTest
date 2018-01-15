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

protocol IAPDelegate: class {
    func showiTuneLogin()
}

class MoneyUnlimitedViewController: UIViewController {
    @IBOutlet weak var moneyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var unlimitedLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hyperlinkLabel: UILabel!
    var delegate: IAPDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(onClicLabel(sender:)))
        hyperlinkLabel.isUserInteractionEnabled = true
        hyperlinkLabel.addGestureRecognizer(tap)
    }
    
    func retrieveProductIAP() {
        SwiftyStoreKit.retrieveProductsInfo(["11212017"]) { result in
            if let product = result.retrievedProducts.first {
                AppEventsLogger.log("IAP prompt shown")
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                self.alert(message: invalidProductId)
            }
            else {
                self.alert(message: (result.error?.localizedDescription)!)
            }
        }
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
            unlimitedLabelHeightConstraint.constant = 210
        }
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        delegate?.showiTuneLogin()
        navigationController?.popViewController(animated: false)
    }

    @IBAction func okayButtonAction(_ sender: Any) {
        self.perform(#selector(inAppPurchase), with: nil, afterDelay: 0.0)
    }
    
    @objc func inAppPurchase() {
        delegate?.showiTuneLogin()
        navigationController?.popViewController(animated: false)
    }
  }

