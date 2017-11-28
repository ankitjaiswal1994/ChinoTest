//
//  Crypto+NavigationBar.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import Foundation
import UIKit

enum CryptoConstant {
    
    struct navigationTitle {
        static let collectCurrency = "Collect Currency"
        static let selectCurrency = "Select Currency"
    }
    
    struct color {
        static let toggleButtonBackgroundColor = UIColor(red: 11.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    struct urls {
        static let getCryptoCoinApiUrl = "https://www.cryptocompare.com/api/data/coinlist/"
    }
    
    struct alertMessages {
        static let selectThreeCurrency = "Select up to 3 alternate currencies."
        static let noDataFound = "No Data Found"
        static let noInternetconnection = "No Internet Connection."
        static let enterSomeValue = "Please enter some value"
    }
    
    struct alertTitle {
        static let notice = "Notice"
        static let error = "Error!"
    }
    
    struct storyBoardName {
        static let currencyExchange = "CurrencyExchange"
    }
    
    struct identifiers {
        static let selectCurrencyViewController = "SelectCurrencyViewController"
        static let convertedCurrencyViewController = "ConvertedCurrencyViewController"
        static let headerView = "HeaderView"
    }
    
    struct keys {
        static let baseImageUrl = "BaseImageUrl"
        static let data = "Data"
        static let response = "Response"
        static let price = "price"
    }
    
    struct imageName {
        static let bitCoin = "bitcoin"
    }
    
    struct jsonText {
        static let countryList = "CountryList"
        static let success = "Success"
    }
}
    


