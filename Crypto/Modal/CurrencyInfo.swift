//
//  currencyInfo.swift
//  Crypto
//
//  Created by Crownstack on 17/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import Foundation

class CurrencyInfo {
    var icon = ""
    var name = ""
    var code = ""
    var currencyPrice = ""
    var isSelected = false
    var continentName = ""
    var counryArray = [CurrencyInfo]()
    
    var imageUrl = ""
    var coinName = ""
    var symbol = ""
    var sortOrder = ""
    
    class func parseCurrencyList(dict: NSDictionary) -> CurrencyInfo {
        let currencyObject = CurrencyInfo()
        currencyObject.icon = dict.value(forKey: "icon") as? String ?? ""
        currencyObject.name = dict.value(forKey: "name") as? String ?? ""
        currencyObject.code = dict.value(forKey: "code") as? String ?? ""
        
        return currencyObject
    }
    
    class func getContinentWithCountry(dict: NSDictionary) -> CurrencyInfo {
        let currencyObject = CurrencyInfo()
        currencyObject.continentName = dict.value(forKey: "continentName") as? String ?? ""
        if let countryArray = dict.value(forKey: "continentCountrys") as? Array<Dictionary<String, Any>> {
            for country in countryArray {
                currencyObject.counryArray.append(CurrencyInfo.parseCurrencyList(dict: country as NSDictionary))
            }
        }
        currencyObject.counryArray = currencyObject.counryArray.sorted(by: {$0.code < $1.code})
        
        return currencyObject
    }
    
    class func getCryptoCurrencyList(dict: NSDictionary) -> CurrencyInfo {
        let currencyObject = CurrencyInfo()
        currencyObject.imageUrl = dict.value(forKey: "ImageUrl") as? String ?? ""
        currencyObject.coinName = dict.value(forKey: "CoinName") as? String ?? ""
        currencyObject.code = dict.value(forKey: "Symbol") as? String ?? ""
        currencyObject.sortOrder = dict.value(forKey: "SortOrder") as? String ?? ""
        
        return currencyObject
    }
}