//
//  ConvertedCurrencyViewController.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit

class ConvertedCurrencyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ConvertedCurrencyTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    var currencyInfo = [CurrencyInfo]()
    
    override func viewDidLoad() {
        
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
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=INR&tsyms=BTC,USD,GBP") else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? NSDictionary {
                     
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
        cell.currencyType.text = "BTC"
        cell.currencyValue.text = "1823764812364"
        cell.currencyName.text = "Bitcoin"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SwifterSwift.isPhone ? 65 : 80
    }
}

