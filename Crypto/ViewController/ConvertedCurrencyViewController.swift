//
//  ConvertedCurrencyViewController.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit

class ConvertedCurrencyViewController: UIViewController {
    
    struct Item {
        var name: String
        var value: Float
    }
    
    var items: [Item]?
    var keys =  [String]()
    var values = [Float]()
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ConvertedCurrencyTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    var currencyInfo = [CurrencyInfo]()
    
    var currency: String = ""
    var selectedArray: String = "" // this contains comma separated values
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UserDefaults.standard.value(forKey: "price") as? String ?? "Currency Price"
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = title
        navigationItem.leftBarButtonItem = CryptoNavigationBar.backButton(self, action: #selector(leftBarButtonAction(_:)))
        getCalculatedData()
    }
    
    @objc func leftBarButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startOverButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: "price")
        UserDefaults.standard.synchronize()
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
        
        
        if indexPath.row < self.keys.count {
            cell.currencyType.text = self.keys[indexPath.row]
        }
        
        if indexPath.row < self.values.count {
            cell.currencyValue.text = "\(self.values[indexPath.row])"
        }
     
        cell.currencyName.text = ""
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SwifterSwift.isPhone ? 65 : 80
    }
}

