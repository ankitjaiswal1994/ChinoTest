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
    
    var search: String = ""
    var countryCurrencyArray = [CurrencyInfo]()
    var selectedArray = [CurrencyInfo]()
    var serachArray = [CurrencyInfo]()
    var continentsNameArray = ["Asia","Africa","North America","South America","Europe"]
    var isCurrencySelect = false
    var selectedCurrency = ""
    
    var keysArray = [Any]()
    var valuesArray = [NSDictionary]()
    var currencyInfoObjectArray = [CurrencyInfo]()
    var imageUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCalculatedData()
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
        
//        if let response = JSONData.load(from: "cryptoIcon") {
//            cryptoCurrencyArray.removeAll()
//            for data in response {
//                cryptoCurrencyArray.append(CurrencyInfo.parseCurrencyList(dict: data as NSDictionary))
//            }
//        }
    }
    
    func getCalculatedData() {
    
        let urlPath = "https://www.cryptocompare.com/api/data/coinlist/"
        guard let url = URL(string: urlPath) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? NSDictionary {
                        if let response = json.value(forKey: "Response") {
                            let baseImageUrl = json.value(forKey: "BaseImageUrl") as! String
                            UserDefaults.standard.set(baseImageUrl, forKey: "BaseImageUrl")
                            self.keysArray = (( json.value(forKey: "Data") as? NSDictionary)?.allKeys)!  
                            self.valuesArray = (( json.value(forKey: "Data") as? NSDictionary)?.allValues)! as! [NSDictionary]
                            for tempDict in self.valuesArray {
                                self.currencyInfoObjectArray.append(CurrencyInfo.getCryptoCurrencyList(dict: tempDict as! NSDictionary))
                            }
                            dispatch {
                                self.collectionView.reloadData()
                            }
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
    
    //Download image
    
    
    
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
        var obj = CurrencyInfo()
        
        if cryptoButton.isSelected {
            obj = search.isEmpty ? currencyInfoObjectArray[indexPath.item] : serachArray[indexPath.item]
        } else {
            let country = search.isEmpty ? countryCurrencyArray[indexPath.section] : serachArray[indexPath.section]
            obj = country.counryArray[indexPath.item]
        }

        cell.currencyName.text = obj.code
        
        if cryptoButton.isSelected {
            if let baseUrl = UserDefaults.standard.value(forKey: "BaseImageUrl") as? String {
                imageUrl = baseUrl + obj.imageUrl
                if let url = URL.init(string: imageUrl) {
                    cell.currencyImage.downloadedFrom(url: url)
                }
            }
        } else {
             cell.currencyImage.image = UIImage(named: obj.icon)

        }
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

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
           // DispatchQueue.main.async() { () -> Void in
                self.image = image
         //   }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}


