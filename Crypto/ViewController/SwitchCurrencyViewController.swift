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
    @IBOutlet weak var confirmButton: UIButton!
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
    var selectedArray = [CurrencyInfo]()
    var isCurrencySelect = false
    
    var currencyNameArray = ["Common Currency","Cryptocurrency"]
    
    
    // selected
    var selectedCurrency = ""
    var selectedItems = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        setUpView()
        currencyList()
    }
    
    @IBAction func cryptoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if sender.isSelected {
            return
        }
        cryptoButton.isSelected = true
        commonButton.isSelected = false
        cryptoButton.backgroundColor = .blue
        commonButton.backgroundColor = .clear
        searchTextField.text = nil
        currencyList()
        collectionView.reloadData()
    }
    
    @IBAction func commonButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if sender.isSelected {
            return
        }
        cryptoButton.isSelected = false
        commonButton.isSelected = true
        cryptoButton.backgroundColor = .clear
        commonButton.backgroundColor = .blue
        searchTextField.text = nil
        currencyList()
        collectionView.reloadData()
    }

    @IBAction func confirmButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CurrencyExchange", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ConvertedCurrencyViewController") as? ConvertedCurrencyViewController else { return }
        
        vc.selectedArray = selectedArray.map({ (cuurency) -> String in
            return cuurency.code
        }).joined(separator: ",")
        
        vc.currency = selectedCurrency
        
            
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpView () {
        
        confirmButton.isHidden = true
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
        if obj.isSelected && selectedArray.count <= 3 {
        cell.selectionView.isHidden = !obj.isSelected
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        if !isCurrencySelect {
        let storyboard = UIStoryboard(name: "CurrencyExchange", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "SelectCurrencyViewController") as? SelectCurrencyViewController else { return }
        vc.delegate = self
        vc.code = searchArray[indexPath.item].code
        vc.name = searchArray[indexPath.item].name
        vc.icon = searchArray[indexPath.item].icon
        navigationController?.pushViewController(vc, animated: true)
        } else {
            let currencyModal = searchArray[indexPath.item]
            currencyModal.isSelected = !currencyModal.isSelected
            if currencyModal.isSelected && selectedArray.count <= 3 {
                selectedArray.append(currencyModal)
                if selectedArray.count == 3 {
                 confirmButton.isHidden = false
                }
            } else if !currencyModal.isSelected {
                selectedArray.remove(at: indexPath.item)
            } else {
                
            }
            collectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: 0)])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3 - 40, height:80 )
    }
}

extension SwitchCurrencyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let text = textField.text ?? ""
        search = string.isEmpty ? String(search.dropLast()) : text + string
        filterForSearchText(search)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
}

extension SwitchCurrencyViewController: SelectCurrencyDelegate {
    
    func showAlert(selectedCurrecny: String) {
        isCurrencySelect = true
        
        self.selectedCurrency = selectedCurrecny
        alert(message: "Select up to 3 alternate currencies", title: "Notice", OKAction: nil)
    }
}

