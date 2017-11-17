//
//  ConvertedCurrencyTableViewCell.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit

class ConvertedCurrencyTableViewCell: UITableViewCell,NibReusable {

    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currencyType: UILabel!
    @IBOutlet weak var currencyValue: UILabel!
    @IBOutlet weak var currencyName: UILabel!
}
