//
//  ConvertedCurrencyViewController.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit

protocol StatrOverDelegate: class {
    func startOver()
}

class ConvertedCurrencyViewController: UIViewController {
    
    struct Item {
        var name: String
        var value: Float
    }
    
    var items: [Item]?
    var keys =  [String]()
    var values = [Float]()
    var flags = [CurrencyInfo]()
    var delegate: StatrOverDelegate?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ConvertedCurrencyTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    var currencyInfo = [CurrencyInfo]()
    var valueForCalculation: Float = 1e+07
    var currency: String = ""
    var selectedArray: String = "" // this contains comma separated values
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if appdelegate.count > 2 {
            alert(message: "In App Purchase")
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
    }
    
    @IBAction func getFreeBitCoinButtonAction(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://goo.gl/6yznGQ")!)
    }
    
    func getCalculatedData() {
        
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
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }).resume()
    }
}

extension ConvertedCurrencyViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ConvertedCurrencyTableViewCell.self)
        
        if indexPath.row < self.flags.count {
            cell.currencyImageView.image = UIImage(named: flags[indexPath.row].icon)
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
        
        cell.currencyName.text = ""
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SwifterSwift.isPhone ? 65 : 80
    }
}

