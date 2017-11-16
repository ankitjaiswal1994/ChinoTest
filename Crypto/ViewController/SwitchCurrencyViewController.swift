//
//  SwitchCurrencyViewController.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit

class SwitchCurrencyViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: SwitchCurrencyCollectionViewCell.self)
        }
    }
    
    var commonCurrencyArray = ["USD","INR","EUR","CAD","AUD","GBP","CNY","JPY","HKD","NZD","SGD","RUB"]
    var cryptoCurrencyArray = ["USD","INR","EUR","CAD","AUD","GBP"]
    var currencyNameArray = ["Common Currency","Cryptocurrency"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpView()
    }
    
    func setUpView () {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = Crypto.navigationTitle.switchCurrency

    }
}

extension SwitchCurrencyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? commonCurrencyArray.count: cryptoCurrencyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SwitchCurrencyCollectionViewCell.self)
        cell.currencyName.text = indexPath.section == 0 ? commonCurrencyArray[indexPath.row]: cryptoCurrencyArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3 - 40, height:80 )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "HeaderView",
                                                                         for: indexPath) as? HeaderView else { return UICollectionReusableView() }
        headerView.currencyName.text = currencyNameArray[indexPath.section]
        headerView.currencyCount.text = indexPath.section == 0 ? String(commonCurrencyArray.count): String(cryptoCurrencyArray.count)
        
        return headerView
    }
}

