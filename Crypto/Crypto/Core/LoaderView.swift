//
//  MessageView.swift
//  EquipmentDepot
//
//  Created by Sagar Kumar on 11/8/17.
//  Copyright © 2017 Equipement Depo. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!

    @IBAction func refreshButtonAction(_ sender: Any) {
        refresh?()
    }

    var refresh: (() -> Void)?

    class func showIndicator(_ onView: UIView) {
        let customView = LoaderView.loadNib()
        customView.createView(customView, message: nil, isShowIndicator: true, isShowMessage: false, onView: onView)
    }

    class func showSearchIndicator(_ onView: UIView) {
        let customView = LoaderView.loadNib()
        customView.createSearchView(customView, message: nil, isShowIndicator: true, isShowMessage: false, onView: onView)
    }

    class func showMessage(_ message: String?, onView: UIView, isSearch: Bool, completion: @escaping (() -> Void)) {
        let customView = LoaderView.loadNib()
        if isSearch {
            customView.createSearchView(customView, message: message, isShowIndicator: false, isShowMessage: true, onView: onView)
        } else {
            customView.createView(customView, message: message, isShowIndicator: false, isShowMessage: true, onView: onView)
        }
        customView.refresh = completion
    }

    func createView(_ customView: LoaderView, message: String?, isShowIndicator: Bool, isShowMessage: Bool, onView: UIView) {
        LoaderView.remove(onView)
        customView.frame = CGRect(x: 20, y: 0, width: onView.frame.width - 40, height: 120)
        customView.center = onView.center
        customView.messageLabel.text = message
        customView.messageLabel.isHidden = isShowIndicator
        customView.activityIndicator.isHidden = isShowMessage
        onView.addSubview(customView)
    }

    func createSearchView(_ customView: LoaderView, message: String?, isShowIndicator: Bool, isShowMessage: Bool, onView: UIView) {
        LoaderView.remove(onView)
        customView.frame = CGRect(x: isShowMessage ? 20 : -20, y: 100, width: onView.frame.width - 40, height: 40)
        customView.messageLabel.text = message
        customView.messageLabel.isHidden = isShowIndicator
        customView.activityIndicator.isHidden = isShowMessage
        customView.loadingLabel.isHidden = isShowMessage
        onView.addSubview(customView)
    }

    class func loadNib() -> LoaderView {
        guard let loaderView = Bundle.main.loadNibNamed("LoaderView", owner: self, options: nil)?.first as? LoaderView else {
            return LoaderView()
        }
        return loaderView
    }

    class func remove(_ view: UIView?) {
        if let subViewArray = view?.subviews {
            for subView in subViewArray where subView is LoaderView {
                subView.removeFromSuperview()
            }
        }
    }
}
