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
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var commonButton: UIButton!
    @IBOutlet weak var cryptoButton: UIButton! {
        didSet {
            cryptoButton.backgroundColor = Crypto.toolBar.toggleButtonBackgroundColor
            cryptoButton.isSelected = true
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: SwitchCurrencyCollectionViewCell.self)
        }
    }
    
    var search: String = ""
    var countryCurrencyArray = [CurrencyInfo]()
    var selectedArray = [CurrencyInfo]()
    var serachArray = [CurrencyInfo]()
    var isCurrencySelect = false
    var selectedCurrency = ""
    var valuesArray = [NSDictionary]()
    var currencyInfoObjectArray = [CurrencyInfo]()
    var imageUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        getCryptoCurrencyData()
        confirmButton.isHidden = true
        currencyList()
        navigationItem.title = Crypto.navigationTitle.selectCurrency
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
        cryptoButton.backgroundColor = Crypto.toolBar.toggleButtonBackgroundColor
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
        commonButton.backgroundColor = Crypto.toolBar.toggleButtonBackgroundColor
        searchTextField.text = nil
        collectionView.reloadData()
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Crypto.storyBoardName.currencyExchange, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Crypto.identifierType.convertedCurrencyViewController) as? ConvertedCurrencyViewController else { return }
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
        if let response = JSONData.load(from: Crypto.urls.countryListUrl) {
            countryCurrencyArray.removeAll()
            for data in response {
                countryCurrencyArray.append(CurrencyInfo.getContinentWithCountry(dict: data as NSDictionary))
            }
        }
    }
    
    func getCryptoCurrencyData() {
    
        let urlPath = Crypto.urls.cryptoCoinListUrl
        guard let url = URL(string: urlPath) else { return }
        LoaderView.showIndicator(view)
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self]
            (data, response, error) in
            guard let _self = self else { return }
            LoaderView.remove(_self.view)
            if(error != nil){
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? NSDictionary {
                        let success = json.value(forKey: Crypto.apiKeys.response) as? String
                        
                        if  success == "Success" {
                            let baseImageUrl = json.value(forKey: Crypto.apiKeys.baseImageUrl) as! String
                            UserDefaults.standard.set(baseImageUrl, forKey: Crypto.apiKeys.baseImageUrl)
                            _self.valuesArray = (( json.value(forKey: Crypto.apiKeys.data) as? NSDictionary)?.allValues)! as! [NSDictionary]
                            for tempDict in _self.valuesArray {
                                _self.currencyInfoObjectArray.append(CurrencyInfo.getCryptoCurrencyList(dict: tempDict as! NSDictionary))
                                _self.currencyInfoObjectArray = _self.currencyInfoObjectArray.sorted(by: {$0.code < $1.code})
                            }
                            dispatch {
                                _self.collectionView.reloadData()
                            }
                        } else {
                            
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }).resume()
    }
    
    func filterForSearchText(_ searchText: String) {
        if cryptoButton.isSelected {
            serachArray = currencyInfoObjectArray.filter {
                $0.code.lowercased().contains(searchText.lowercased()) }
        } else {
            serachArray = countryCurrencyArray.filter {
                $0.continentName.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
}

extension SwitchCurrencyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isCurrencySelect {
            if cryptoButton.isSelected {
                search.isEmpty ? pushToCurrencyExchange(indexPath, array: currencyInfoObjectArray) : pushToCurrencyExchange(indexPath, array: serachArray)
            } else {
                let country = search.isEmpty ? countryCurrencyArray[indexPath.section] : serachArray[indexPath.section]
                pushToCurrencyExchange(indexPath, array: country.counryArray)
            }
        } else {
            if cryptoButton.isSelected {
                search.isEmpty ? refreshCurrency(indexPath, array: currencyInfoObjectArray) : refreshCurrency(indexPath, array: serachArray)
            } else {
                let country = search.isEmpty ? countryCurrencyArray[indexPath.section] : serachArray[indexPath.section]
                refreshCurrency(indexPath, array: country.counryArray)
            }
        }
    }
}

extension SwitchCurrencyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: Crypto.identifierType.headerView,
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
        return cryptoButton.isSelected ? 1 : search.isEmpty ? countryCurrencyArray.count : serachArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cryptoButton.isSelected {
            return  search.isEmpty ? currencyInfoObjectArray.count : serachArray.count
        } else {
            let country = search.isEmpty ? countryCurrencyArray[section] : serachArray[section]
            return country.counryArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SwitchCurrencyCollectionViewCell.self)
        
        var currencyInfoObject = CurrencyInfo()
        if cryptoButton.isSelected {
            currencyInfoObject = search.isEmpty ? currencyInfoObjectArray[indexPath.item] : serachArray[indexPath.item]
        } else {
            let country = search.isEmpty ? countryCurrencyArray[indexPath.section] : serachArray[indexPath.section]
            currencyInfoObject = country.counryArray[indexPath.item]
        }
        cell.currencyName.text = currencyInfoObject.code
        
        if cryptoButton.isSelected {
            if let baseUrl = UserDefaults.standard.value(forKey: Crypto.apiKeys.baseImageUrl) as? String {
                cell.currencyImage.loadImageUsingCache(withUrl: baseUrl + currencyInfoObject.imageUrl)
            }
        } else if commonButton.isSelected {
             cell.currencyImage.image = UIImage(named: currencyInfoObject.icon)
        }
        cell.currencyImage.contentMode = cryptoButton.isSelected ? .scaleAspectFit : .scaleAspectFill
        cell.selectionView.isHidden = !currencyInfoObject.isSelected
       
        return cell
    }
    
    func pushToCurrencyExchange(_ indexPath: IndexPath, array: [CurrencyInfo]) {
        let storyboard = UIStoryboard(name: Crypto.storyBoardName.currencyExchange, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Crypto.identifierType.selectCurrencyViewController) as? SelectCurrencyViewController else { return }
        vc.delegate = self
        let arrayObject = array[indexPath.item]
        vc.code = arrayObject.code
        vc.name = arrayObject.coinName
        if cryptoButton.isSelected {
            if let baseUrl = UserDefaults.standard.value(forKey: Crypto.apiKeys.baseImageUrl) as? String {
                vc.icon = baseUrl + arrayObject.imageUrl
            }
        } else if commonButton.isSelected {
            vc.icon = arrayObject.icon
        }
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
        alert(message: Crypto.alertText.selectThreeCurrencyMessage, title: Crypto.alertText.noticeTitle, OKAction: nil)
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
