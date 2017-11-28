//
//  SwitchCurrencyViewController.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class SwitchCurrencyViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var commonButton: UIButton!
    @IBOutlet weak var cryptoButton: UIButton! {
        didSet {
            cryptoButton.backgroundColor = CryptoConstant.color.toggleButtonBackgroundColor
            cryptoButton.isSelected = true
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: SwitchCurrencyCollectionViewCell.self)
        }
    }
    
    var countryCurrencyArray = [CurrencyInfo]()
    var selectedArray = [CurrencyInfo]()
    var serachArray = [CurrencyInfo]()
    var currencyInfoObjectArray = [CurrencyInfo]()
    var valuesArray = [NSDictionary]()
    var keysArray = [Any]()
    var imageUrl = String()
    var isCurrencySelect = false
    var isLoading = false
    var search: String = ""
    var selectedCurrency = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.isHidden = true
        navigationItem.title = CryptoConstant.navigationTitle.collectCurrency
        searchTextField.text = ""
        commonButtonAction(UIButton())
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
        if (currencyInfoObjectArray.count == 0) {
            getCalculatedData()
        }
        search = ""
        cryptoButton.isSelected = true
        commonButton.isSelected = false
        cryptoButton.backgroundColor = CryptoConstant.color.toggleButtonBackgroundColor
        commonButton.backgroundColor = .clear
        searchTextField.text = nil
        collectionView.reloadData()
    }
    
    @IBAction func commonButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        
        if sender.isSelected {
            return
        }
        countryCurrencyArray.count == 0 ? currencyList(): LoaderView.remove(view)
        search = ""
        cryptoButton.isSelected = false
        commonButton.isSelected = true
        cryptoButton.backgroundColor = .clear
        commonButton.backgroundColor = CryptoConstant.color.toggleButtonBackgroundColor
        searchTextField.text = nil
        collectionView.reloadData()
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: CryptoConstant.storyBoardName.currencyExchange, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: CryptoConstant.identifiers.convertedCurrencyViewController) as? ConvertedCurrencyViewController else { return }
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
        if let response = JSONData.load(from: CryptoConstant.jsonText.countryList) {
            countryCurrencyArray.removeAll()
            for data in response {
                countryCurrencyArray.append(CurrencyInfo.getContinentWithCountry(dict: data as NSDictionary))
            }
        }
    }
    
    func getCalculatedData() {
        
        LoaderView.showIndicator(view)
        if let internet = NetworkReachabilityManager(), internet.isReachable {
            let urlPath = CryptoConstant.urls.getCryptoCoinApiUrl
            guard let url = URL(string: urlPath) else { return }
            URLSession.shared.dataTask(with: url, completionHandler: { [weak self]
                (data, response, error) in
                guard let _self = self else { return }
                LoaderView.remove(_self.view)
                _self.isLoading = false
                if(error != nil){
                    print("error")
                } else {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? NSDictionary {
                            if json.value(forKey: CryptoConstant.keys.response) as? String == CryptoConstant.jsonText.success {
                                let baseImageUrl = json.value(forKey: CryptoConstant.keys.baseImageUrl) as! String
                                UserDefaults.standard.set(baseImageUrl, forKey: CryptoConstant.keys.baseImageUrl)
                                _self.keysArray = (( json.value(forKey: CryptoConstant.keys.data) as? NSDictionary)?.allKeys)!
                                _self.valuesArray = (( json.value(forKey: CryptoConstant.keys.data) as? NSDictionary)?.allValues)! as! [NSDictionary]
                                for tempDict in _self.valuesArray {
                                    _self.currencyInfoObjectArray.append(CurrencyInfo.getCryptoCurrencyList(dict: tempDict))
                                    _self.currencyInfoObjectArray = _self.currencyInfoObjectArray.sorted(by: {$0.code < $1.code})
                                }
                                dispatch {
                                    _self.collectionView.reloadData()
                                }
                            }  else {
                                _self.alert(message: CryptoConstant.alertMessages.noDataFound, title: CryptoConstant.alertTitle.error, OKAction: nil)
                                LoaderView.showMessage(CryptoConstant.alertMessages.noDataFound, onView: _self.view, isSearch: false, completion: { [weak self] in
                                    guard let _self = self else { return }
                                    _self.getCalculatedData()
                                })
                            }
                        }
                    } catch let error as NSError {
                        LoaderView.showMessage("\(error)", onView: _self.view, isSearch: false, completion: { [weak self] in
                            guard let _self = self else { return }
                            _self.getCalculatedData()
                        })
                    }
                }
            }).resume()
        } else {
            LoaderView.showMessage(CryptoConstant.alertMessages.noInternetconnection, onView: view, isSearch: false, completion: { [weak self] in
                guard let _self = self else { return }
                _self.getCalculatedData()
            })
        }
    }
    
    func filterForSearchText(_ searchText: String) {
        if cryptoButton.isSelected {
            serachArray = currencyInfoObjectArray.filter {
                $0.name.lowercased().contains(searchText.lowercased()) || $0.code.lowercased().contains(searchText.lowercased())}
        } else {
            let array = countryCurrencyArray
            for index in array {
                index.filterArray = index.counryArray.filter{
                    $0.name.lowercased().contains(searchText.lowercased()) || $0.code.lowercased().contains(searchText.lowercased()) }
            }
            countryCurrencyArray = array
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
                let country = countryCurrencyArray[indexPath.section]
                pushToCurrencyExchange(indexPath, array: search.isEmpty ? country.counryArray : country.filterArray)
            }
        } else {
            if cryptoButton.isSelected {
                search.isEmpty ? refreshCurrency(indexPath, array: currencyInfoObjectArray) : refreshCurrency(indexPath, array: serachArray)
            } else {
                let country = countryCurrencyArray[indexPath.section]
                refreshCurrency(indexPath, array: search.isEmpty ? country.counryArray : country.filterArray)
            }
        }
    }
}

extension SwitchCurrencyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: CryptoConstant.identifiers.headerView,
                                                                               for: indexPath) as? HeaderView else { return UICollectionReusableView() }
        let country = countryCurrencyArray[indexPath.section]
        headerView.sectionLabel.text = country.continentName
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.size.width/3 - 35, height:90 )
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
        if cryptoButton.isSelected {
            
            return  search.isEmpty ? currencyInfoObjectArray.count : serachArray.count
        } else {
            let country = countryCurrencyArray[section]
            
            return search.isEmpty ? country.counryArray.count : country.filterArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SwitchCurrencyCollectionViewCell.self)
        var obj = CurrencyInfo()
        
        if cryptoButton.isSelected {
            obj = search.isEmpty ? currencyInfoObjectArray[indexPath.item] : serachArray[indexPath.item]
        } else {
            let country = countryCurrencyArray[indexPath.section]
            obj = search.isEmpty ? country.counryArray[indexPath.item] : country.filterArray[indexPath.item]
        }
        cell.currencyName.text = obj.code
        
        if cryptoButton.isSelected {
            if let baseUrl = UserDefaults.standard.value(forKey: CryptoConstant.keys.baseImageUrl) as? String {
                cell.currencyImage.af_setImage(withURL: URL(string:  baseUrl + obj.imageUrl)!, placeholderImage: UIImage(named: CryptoConstant.imageName.bitCoin))
            }
        } else if commonButton.isSelected {
            cell.currencyImage.image = UIImage(named: obj.icon)
        }
        cell.currencyImage.contentMode = cryptoButton.isSelected ? .scaleAspectFit : .scaleAspectFill
        cell.selectionView.isHidden = !obj.isSelected
        
        return cell
    }
}

extension SwitchCurrencyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        search = string.isEmpty ? String(search.dropLast()) : text + string
        filterForSearchText(search)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        search = ""
        filterForSearchText(search)
        
        return true
    }
}

extension SwitchCurrencyViewController: SelectCurrencyDelegate {
    
    func showAlert(selectedCurrecny: String,  changeTitle: String) {
        isCurrencySelect = true
        title = changeTitle
        selectedCurrency = selectedCurrecny
        searchTextField.text = ""
        search = ""
        currencyList()
        collectionView.reloadData()
        alert(message: CryptoConstant.alertMessages.selectThreeCurrency, title: CryptoConstant.alertTitle.notice, OKAction: nil)
    }
}

extension SwitchCurrencyViewController {
    
    func pushToCurrencyExchange(_ indexPath: IndexPath, array: [CurrencyInfo]) {
        let storyboard = UIStoryboard(name: CryptoConstant.storyBoardName.currencyExchange, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: CryptoConstant.identifiers.selectCurrencyViewController) as? SelectCurrencyViewController else { return }
        vc.delegate = self
        let obj = array[indexPath.item]
        vc.code = obj.code
        vc.name = obj.name
        if cryptoButton.isSelected {
            if let baseUrl = UserDefaults.standard.value(forKey: CryptoConstant.keys.baseImageUrl) as? String {
                vc.icon = baseUrl + obj.imageUrl
            }
        } else if commonButton.isSelected {
            vc.icon = obj.icon
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

extension SwitchCurrencyViewController: StatrOverDelegate {
    
    func startOver() {
        isCurrencySelect = false
        search = ""
        selectedArray = [CurrencyInfo]()
        for crypto in currencyInfoObjectArray {
            crypto.isSelected = false
        }
        confirmButton.isHidden = true
        currencyList()
        collectionView.reloadData()
        navigationItem.title = CryptoConstant.navigationTitle.collectCurrency
    }
}
