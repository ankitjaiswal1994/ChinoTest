//
//  Crypto+NavigationBar.swift
//  Crypto
//
//  Created by Crownstack on 17/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import Foundation
import UIKit

open class CryptoNavigationBar {
    
    typealias Action = () -> Void
    
    class func backButton(_ controller: Any, action: Selector) -> UIBarButtonItem {
        return NavigationBar.leftBarButton(controller, buttonImage: UIImage(named: "leftarrow")!, action: action)
    }

    class func leftBarCustomButton(_ controller: Any, normalImage: UIImage, selectedImage: UIImage, action: Selector) -> UIBarButtonItem {
        let customView = ORDesignableView.init(frame: CGRect(x: 0, y: 0, width: 60.0, height: 25.0))
        customView.backgroundColor = .black
        customView.cornerRadius = 2
        
        let mapListButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: customView.frame.size.width, height: customView.frame.size.height))
        mapListButton.setImage(normalImage, for: .normal)
        mapListButton.setImage(selectedImage, for: .selected)
        mapListButton.addTarget(controller, action: action, for: .touchUpInside)
        
        customView.addSubview(mapListButton)
        let barButtonItem = UIBarButtonItem(customView: customView)
        
        return barButtonItem
    }
}
