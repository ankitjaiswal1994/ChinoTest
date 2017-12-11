//
//  TermsViewController.swift
//  Crypto
//
//  Created by Speedy Singh on 12/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = CryptoNavigationBar.leftBarButtonWithTitle(self, buttonTitle: "Done", action: #selector(leftBarButtonTitleAction(_:)))
        
        if let url = URL(string: "https://goo.gl/VHB1Tq") {
            LoaderView.showIndicator(view)
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    @objc func leftBarButtonTitleAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension TermsViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoaderView.remove(view)
    }
}
