//
//  SwitchCurrencyCollectionViewCell.swift
//  Demo Project
//
//  Created by Crownstack on 15/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit
import Foundation

class SwitchCurrencyCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var selectionView: UIView!
    
    override func awakeFromNib() {
        currencyImage.layer.shadowColor = UIColor(white: 0.7, alpha: 0.7).cgColor
        currencyImage.layer.shadowOffset = CGSize.init(width: 2.0, height: 2.0)
        currencyImage.layer.shadowOpacity = 0.5
        currencyImage.layer.masksToBounds = false
        currencyImage.layer.cornerRadius = 5
    }
}
