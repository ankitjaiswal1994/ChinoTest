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
        let customView = ORDesignableView.init(frame: CGRect(x: 0, y: 0, width: 40.0, height: 25.0))
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
    
    class func rightBarButtonWithTitle(_ controller: Any, buttonTitle: String, action: Selector) -> UIBarButtonItem {
        let barButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 70.0, height: 30.0)
        barButton.setTitle(buttonTitle, for: .normal)
        barButton.contentHorizontalAlignment = .right
        barButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        barButton.setTitleColor(.black, for: .normal)
        barButton.addTarget(controller, action: action, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: barButton)
        
        return barButtonItem
    }
    
    class func leftBarButtonWithTitle(_ controller: Any, buttonTitle: String, action: Selector) -> UIBarButtonItem {
        let barButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 50.0, height: 30.0)
        barButton.setTitle(buttonTitle, for: .normal)
        barButton.contentHorizontalAlignment = .left
        barButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        barButton.setTitleColor(.black, for: .normal)
        barButton.addTarget(controller, action: action, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: barButton)
        
        return barButtonItem
    }
}
