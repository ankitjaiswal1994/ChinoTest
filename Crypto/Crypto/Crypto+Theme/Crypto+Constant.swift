//
//  Crypto+NavigationBar.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import Foundation
import UIKit

enum Crypto {
    
    struct navigationTitle {
        static let switchCurrency = "Collect Currency"
        static let selectCurrency = "Select Currency"
    }
    
    struct apiKeys {
        static let response = "Response"
        static let baseImageUrl = "BaseImageUrl"
        static let data = "Data"
        static let price = "price"
    }
    
    struct toolBar {
        static  let barTintColor = UIColor(red: 0/255.0, green: 240.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        static let tintColor = UIColor.white
        static let toggleButtonBackgroundColor = UIColor(red: 11.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    struct alertText {
        static let selectThreeCurrencyMessage = "Select up to 3 alternate currencies"
        static let noticeTitle = "Notice"
    }
    
    struct storyBoardName {
        static let currencyExchange = "CurrencyExchange"
    }
    
    struct identifierType {
        static let convertedCurrencyViewController = "ConvertedCurrencyViewController"
        static let selectCurrencyViewController = "SelectCurrencyViewController"
        static let headerView = "HeaderView"
    }
    
    struct urls {
        static let cryptoCoinListUrl = "https://www.cryptocompare.com/api/data/coinlist/"
        static let countryListUrl = "CountryList"
    }
    
    struct title {
        static let toolBarButtonTitle = "Confirm Quantity"
    }
    
}
    


