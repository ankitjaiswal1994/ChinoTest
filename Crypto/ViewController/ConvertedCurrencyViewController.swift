//
//  ConvertedCurrencyViewController.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import FacebookCore

protocol StatrOverDelegate: class {
    func startOver()
}

class ConvertedCurrencyViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    struct Item {
        var name: String
        var value: Float
    }
    
    var items: [Item]?
    var keys =  [String]()
    var values = [Float]()
    var currencyName = [String]()
    var flags = [CurrencyInfo]()
    var delegate: StatrOverDelegate?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ConvertedCurrencyTableViewCell.self)
            tableView.tableFooterView = UIView()
            tableView.addSubview(self.refreshControl)
        }
    }
    
    var currencyInfo = [CurrencyInfo]()
    var valueForCalculation: Float = 1e+07
    var currency: String = ""
    var selectedArray: String = "" // this contains comma separated values
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        if let title = UserDefaults.standard.value(forKey: "price") as? String {
            let value = title.components(separatedBy: " ")
            if let quantity = value.first, let doubleValue = Float(quantity) {
                valueForCalculation = doubleValue
            }
            navigationItem.title = title
        }
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = CryptoNavigationBar.backButton(self, action: #selector(leftBarButtonAction(_:)))
        
        getCalculatedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appdelegate.count += 1
        
        if appdelegate.count > 1 {
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
            self.perform(#selector(inAppPurchase), with: nil, afterDelay: 3.0)

            appdelegate.count = 0
        }
    }
    
    @objc func leftBarButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startOverButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: "price")
        UserDefaults.standard.synchronize()
        delegate?.startOver()
        AppEventsLogger.log("Start Over")
    }
    
    @IBAction func getFreeBitCoinButtonAction(_ sender: UIButton) {
        AppEventsLogger.log("Get Free Bitcoin")
        UIApplication.shared.open(URL(string: "https://goo.gl/6yznGQ")!)
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
    
    func getCalculatedData() {
        dispatch {
            self.activityIndicator.startAnimating()
        }
        let urlPath = "https://min-api.cryptocompare.com/data/price?fsym=\(currency)&tsyms=\(selectedArray)"
        guard let url = URL(string: urlPath) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? NSDictionary {
                        self.keys = json.allKeys as? [String] ?? []
                        self.values = json.allValues as? [Float] ?? []
                    }
                    dispatch {
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                    
                } catch let error as NSError {
                    self.activityIndicator.stopAnimating()
                    print(error)
                }
            }
        }).resume()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ConvertedCurrencyViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.lightGray
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        getCalculatedData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension ConvertedCurrencyViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ConvertedCurrencyTableViewCell.self)
        
        if indexPath.row < self.flags.count {
            cell.currencyImageView.image = UIImage(named: flags[indexPath.row].icon)
            print(flags[indexPath.row].name)
            cell.currencyName.text = flags[indexPath.row].name
        }
        
        if indexPath.row < self.keys.count {
            cell.currencyType.text = self.keys[indexPath.row]
        }
        
        if indexPath.row < self.values.count {
            if self.values[indexPath.row] >= 1 {
                cell.currencyValue.text = String(format: "%.2f", self.values[indexPath.row] * valueForCalculation)
            } else {
                cell.currencyValue.text = String(format: "%.8f", self.values[indexPath.row] * valueForCalculation)
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SwifterSwift.isPhone ? 65 : 80
    }
}

