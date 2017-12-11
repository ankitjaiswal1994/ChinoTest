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
import Alamofire

protocol StatrOverDelegate: class {
    func startOver()
}

class ConvertedCurrencyViewController: UIViewController {
    
    struct Item {
        var name: String
        var value: Float
    }
    
    var items: [Item]?
    var currencyName = [String]()
    var flags = [CurrencyInfo]()
    var delegate: StatrOverDelegate?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        if let title = UserDefaults.standard.value(forKey: CryptoConstant.keys.price) as? String {
            let value = title.components(separatedBy: " ")
            if let quantity = value.first, let doubleValue = Float(quantity) {
                valueForCalculation = doubleValue
            }
            navigationItem.title = title
        }
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItems = [CryptoNavigationBar.backButton(self, action: #selector(leftBarButtonAction(_:))), CryptoNavigationBar.leftBarButtonWithTitle(self, buttonTitle: "Terms", action: #selector(leftBarButtonTitleAction(_:)))]
        navigationItem.rightBarButtonItem = CryptoNavigationBar.rightBarButtonWithTitle(self, buttonTitle: "Restore", action: #selector(rightBarButtonTitleAction(_:)))

        getCalculatedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appdelegate.count += 1
        
        if appdelegate.count > 0 {
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
            
            appdelegate.count = -1
        }
    }
    
    @objc func leftBarButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonTitleAction(_ sender: Any) {
       
    }
    
    @objc func leftBarButtonTitleAction(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func startOverButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: CryptoConstant.keys.price)
        UserDefaults.standard.synchronize()
        delegate?.startOver()
        AppEventsLogger.log("Start Over")
    }
    
    @IBAction func getFreeBitCoinButtonAction(_ sender: UIButton) {
        AppEventsLogger.log("Get Free Bitcoin")
        UIApplication.shared.open(URL(string: "https://goo.gl/6yznGQ")!)
    }
    
    @objc func inAppPurchase() {
        
        let message = """
    UPGRADE
    - Unlimted cryptocurrency-to-cryptocurrency converstions
    - Unlimted common currency-to-common currency converstions
    - Unlimted common currency to cryptocurrency converstions

    100% Free Peace of Mind

    30-day free trial.
    $39.99 yearly auto-renewing subsciption after your trial unless turned off, cancel anytime in account settings. Cost & protection of renewal is equal to initial subsciption. Go to bit.ly/dvapp for full details
    """
        
        alertWithTwoAction(message: message, title: "UNLIMITED CONVERSIONS", OkButtonTitle: "Turn On", cancelButtonTitle: "Disable") { (action) in
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
    
    func getCalculatedData() {
        if let internet = NetworkReachabilityManager(), internet.isReachable {
            
            dispatch {
                self.activityIndicator.startAnimating()
                LoaderView.remove(self.view)
            }
            let codeArray = flags.map({ (cuurency) -> String in
                return cuurency.code
            }).joined(separator: ",")
            let urlPath = "https://min-api.cryptocompare.com/data/price?fsym=\(currency)&tsyms=\(codeArray)"
            guard let url = URL(string: urlPath) else { return }
            URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                LoaderView.remove(self.view)
                if(error != nil){
                    print("error")
                } else {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? NSDictionary {
                            for dict in json {
                                let currencyObject = self.flags.first(where: { $0.code == dict.key as? String })
                                currencyObject?.isSuccess = true
                                if let value = dict.value as? Float {
                                    currencyObject?.values = value
                                }
                            }
                        } else {
                            self.alert(message: CryptoConstant.alertMessages.noDataFound, title: CryptoConstant.alertTitle.error, OKAction: nil)
                            LoaderView.showMessage(CryptoConstant.alertMessages.noDataFound, onView: self.view, isSearch: false, completion: { [weak self] in
                                guard let _self = self else { return }
                                _self.getCalculatedData()
                            })
                        }
                        dispatch {
                            self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                    } catch let error as NSError {
                        LoaderView.showMessage("\(error)", onView: self.view, isSearch: false, completion: { [weak self] in
                            guard let _self = self else { return }
                            _self.getCalculatedData()
                        })
                    }
                }
            }).resume()}
        else {
            LoaderView.showMessage(CryptoConstant.alertMessages.noInternetconnection, onView: view, isSearch: false, completion: { [weak self] in
                guard let _self = self else { return }
                _self.getCalculatedData()
            })
        }
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
        
        return flags.count > 0 ? flags.count: 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ConvertedCurrencyTableViewCell.self)
        
        if indexPath.row < self.flags.count {
            if flags[indexPath.row].imageUrl.isEmpty {
                cell.currencyImageView.image = UIImage(named: flags[indexPath.row].icon)
            } else {
                if let baseUrl = UserDefaults.standard.value(forKey: CryptoConstant.keys.baseImageUrl) as? String {
                    cell.currencyImageView.loadImageUsingCache(withUrl: baseUrl + flags[indexPath.row].imageUrl)
                }
            }
            if verifyUrl(urlString: flags[indexPath.row].icon) {
            } else {
            }
            cell.currencyName.text = flags[indexPath.row].name
        }
        
        if indexPath.row < flags.count {
            cell.currencyType.text = flags[indexPath.row].code
        }
        
        if indexPath.row < flags.count {
            if flags[indexPath.row].isSuccess {
                if flags[indexPath.row].values >= 1 {
                    cell.currencyValue.text = String(format: "%.2f", flags[indexPath.row].values * valueForCalculation)
                } else {
                    cell.currencyValue.text = String(format: "%.8f", flags[indexPath.row].values * valueForCalculation)
                }
            } else {
                cell.currencyValue.text = CryptoConstant.alertMessages.noDataFound
            }
            
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 95
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString, let url = NSURL(string: urlString) {
            
            return UIApplication.shared.canOpenURL(url as URL)
        }
        
        return false
    }
}

