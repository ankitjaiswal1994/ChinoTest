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
    
    class func parseCurrencyList(dict: NSDictionary) -> CurrencyInfo {
        let currencyObject = CurrencyInfo()
        currencyObject.icon = dict.value(forKey: "icon") as? String ?? ""
        currencyObject.name = dict.value(forKey: "name") as? String ?? ""
        currencyObject.code = dict.value(forKey: "code") as? String ?? ""
        
        return currencyObject
    }
}
