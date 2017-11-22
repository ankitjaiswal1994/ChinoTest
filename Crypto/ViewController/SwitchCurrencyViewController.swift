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
            cryptoButton.backgroundColor = UIColor(red: 11.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            

            cryptoButton.isSelected = true
        }
    }
    
    var search: String=""
    var cryptoCurrencyArray = [CurrencyInfo]()
    var countryCurrencyArray = [CurrencyInfo]()
    var selectedArray = [CurrencyInfo]()
    var serachArray = [CurrencyInfo]()
    var continentsNameArray = ["Asia","Africa","North America","South America","Europe"]
    var isCurrencySelect = false
    var selectedCurrency = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.isHidden = true
        currencyList()
        navigationItem.title = Crypto.navigationTitle.switchCurrency
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpView()
    }
    
    @IBAction func cryptoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if sender.isSelected {
            return
        }
        search = ""
        cryptoButton.isSelected = true
        commonButton.isSelected = false
        cryptoButton.backgroundColor = UIColor(red: 11.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1.0)

        commonButton.backgroundColor = .clear
        searchTextField.text = nil
        collectionView.reloadData()
    }
    
    @IBAction func commonButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if sender.isSelected {
            return
        }
        search = ""
        cryptoButton.isSelected = false
        commonButton.isSelected = true
        cryptoButton.backgroundColor = .clear
        commonButton.backgroundColor = UIColor(red: 11.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        searchTextField.text = nil
        collectionView.reloadData()
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CurrencyExchange", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ConvertedCurrencyViewController") as? ConvertedCurrencyViewController else { return }
        vc.delegate = self
        vc.selectedArray = selectedArray.map({ (cuurency) -> String in
            return cuurency.code
        }).joined(separator: ",")
        vc.flags = selectedArray
        vc.currency = selectedCurrency
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpView () {
        navigationController?.navigationBar.isHidden = false
    }
    
    func currencyList() {
        if let response = JSONData.load(from: "CountryList") {
            countryCurrencyArray.removeAll()
            for data in response {
                countryCurrencyArray.append(CurrencyInfo.getContinentWithCountry(dict: data as NSDictionary))
            }
        }
        
        if let response = JSONData.load(from: "cryptoIcon") {
            cryptoCurrencyArray.removeAll()
            for data in response {
                cryptoCurrencyArray.append(CurrencyInfo.parseCurrencyList(dict: data as NSDictionary))
            }
        }
    }
    
    func filterForSearchText(_ searchText: String) {
//        serachArray = cryptoButton.isSelected ? cryptoCurrencyArray.filter {
//            $0.code.lowercased().contains(searchText.lowercased()) } : countryCurrencyArray.filter {
//                $0.code.lowercased().contains(searchText.lowercased()) }
//        collectionView.reloadData()
    }
}

extension SwitchCurrencyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isCurrencySelect {
            if search.isEmpty {
                if cryptoButton.isSelected {
                    pushToCurrencyExchange(indexPath, array: cryptoCurrencyArray)
                } else {
                    let country = countryCurrencyArray[indexPath.section]
                    pushToCurrencyExchange(indexPath, array: country.counryArray)
                }
                
            } else {
                pushToCurrencyExchange(indexPath, array: serachArray)
            }
        } else {
            if search.isEmpty {
                if cryptoButton.isSelected {
                    refreshCurrency(indexPath, array: cryptoCurrencyArray)
                } else {
                    let country = countryCurrencyArray[indexPath.section]
                    refreshCurrency(indexPath, array: country.counryArray)
                }
            } else {
                refreshCurrency(indexPath, array: serachArray)
            }
        }
    }
}

extension SwitchCurrencyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "HeaderView",
                                                                               for: indexPath) as? HeaderView else { return UICollectionReusableView() }
        let country = countryCurrencyArray[indexPath.section]
        headerView.sectionLabel.text = country.continentName
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3 - 40, height:80 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return section == 0 ? CGSize(width: 0, height: 0): CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
}

extension SwitchCurrencyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cryptoButton.isSelected ? 1 : countryCurrencyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if search.isEmpty {
            if cryptoButton.isSelected {
                return cryptoCurrencyArray.count
            } else {
                let country = countryCurrencyArray[section]
                return country.counryArray.count
            }
        } else {
            return serachArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SwitchCurrencyCollectionViewCell.self)
        var obj = CurrencyInfo()
        if search.isEmpty {
            if cryptoButton.isSelected {
                obj = cryptoCurrencyArray[indexPath.item]
            } else {
                let country = countryCurrencyArray[indexPath.section]
                obj = country.counryArray[indexPath.item]
            }
        } else {
            obj = serachArray[indexPath.item]
        }
        cell.currencyName.text = obj.code
        cell.currencyImage.image = UIImage(named: obj.icon)
        cell.currencyImage.contentMode = cryptoButton.isSelected ? .scaleAspectFit : .scaleAspectFill
        cell.selectionView.isHidden = !obj.isSelected
        return cell
    }
    
    func pushToCurrencyExchange(_ indexPath: IndexPath, array: [CurrencyInfo]) {
        let storyboard = UIStoryboard(name: "CurrencyExchange", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SelectCurrencyViewController") as? SelectCurrencyViewController else { return }
        vc.delegate = self
        let obj = array[indexPath.item]
        vc.code = obj.code
        vc.name = obj.name
        vc.icon = obj.icon
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refreshCurrency(_ indexPath: IndexPath, array: [CurrencyInfo])  {
        let currencyModal = array[indexPath.item]
        currencyModal.isSelected = !currencyModal.isSelected
        if currencyModal.isSelected && selectedArray.count < 3 {
            selectedArray.append(currencyModal)
        } else if !currencyModal.isSelected {
            if let index = selectedArray.index(where: {$0 === currencyModal}) {
                selectedArray.remove(at: index)
            }
        } else {
            currencyModal.isSelected = !currencyModal.isSelected
        }
        confirmButton.isHidden = selectedArray.count >= 1 ? false: true
        collectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: indexPath.section)])
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
    
    func showAlert(selectedCurrecny: String,  changeTitle: String) {
        isCurrencySelect = true
        title = changeTitle
        self.selectedCurrency = selectedCurrecny
        alert(message: "Select up to 3 alternate currencies", title: "Notice", OKAction: nil)
    }
}

extension SwitchCurrencyViewController: StatrOverDelegate {
    
    func startOver() {
        isCurrencySelect = false
        search = ""
        selectedArray = [CurrencyInfo]()
        confirmButton.isHidden = true
        currencyList()
        collectionView.reloadData()
    }
}

