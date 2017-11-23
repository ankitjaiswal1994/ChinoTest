//
//  JsonDataRead.swift
//  EquipmentDepot
//
//  Created by Crownstack on 09/10/17.
//  Copyright © 2017 Equipement Depo. All rights reserved.
//

import Foundation

open class JSONData {

    open class func load(from fileName: String) -> JSONArray? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? JSONArray
                return jsonResult
            } catch {
                // handle error
            }
        }

        return nil
    }
}
