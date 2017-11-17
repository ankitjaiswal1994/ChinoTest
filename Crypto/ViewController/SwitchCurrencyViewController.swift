//
//  SwitchCurrencyViewController.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit

class SwitchCurrencyViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: SwitchCurrencyCollectionViewCell.self)
        }
    }
    @IBOutlet weak var commonButton: UIButton!
    @IBOutlet weak var cryptoButton: UIButton! {
        didSet {
            cryptoButton.backgroundColor = .blue
            cryptoButton.isSelected = true
        }
    }
    var search: String=""
    var currencyObject = [CurrencyInfo]()
    var searchArray = [CurrencyInfo]()
    var currencyNameArray = ["Common Currency","Cryptocurrency"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
        currencyList()
    }
    
    @IBAction func toggleButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        cryptoButton.isSelected = false
        commonButton.isSelected = false
        cryptoButton.backgroundColor = .clear
        commonButton.backgroundColor = .clear
        sender.backgroundColor = .blue
        sender.isSelected = true
        searchTextField.text = nil
        currencyList()
        collectionView.reloadData()
    }
    
    func setUpView () {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = Crypto.navigationTitle.switchCurrency
    }
    
    func currencyList() {
        if let response = JSONData.load(from: cryptoButton.isSelected ? "cryptoIcon" : "CountryList") {
            currencyObject.removeAll()
            for data in response {
                currencyObject.append(CurrencyInfo.parseCurrencyList(dict: data as NSDictionary))
            }
            searchArray = currencyObject
        }
    }
    
    func filterForSearchText(_ searchText: String) {
        searchArray = searchText.isEmpty ? currencyObject : currencyObject.filter {
            $0.code.lowercased().contains(searchText.lowercased()) }
        collectionView.reloadData()
    }
}

extension SwitchCurrencyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SwitchCurrencyCollectionViewCell.self)
        
        var obj = CurrencyInfo()
        obj = searchArray[indexPath.item]
        
        cell.currencyName.text = obj.code
        cell.currencyImage.image = UIImage(named: obj.icon)
        cell.currencyImage.contentMode = cryptoButton.isSelected ? .scaleAspectFit : .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3 - 40, height:80 )
    }
}

extension SwitchCurrencyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        search = string.isEmpty ? String(search.dropLast()) : textField.text!+string
        filterForSearchText(search)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
}

