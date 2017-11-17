//
//  SelectCurrencyViewController.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit

class SelectCurrencyViewController: UIViewController {

    @IBOutlet weak var currencyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        currencyTextField.becomeFirstResponder()
        addToolBar(textField: currencyTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = Crypto.navigationTitle.selectCurrency
    }
}

extension SelectCurrencyViewController: UITextFieldDelegate {
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Crypto.toolBar.tintColor
        toolBar.barTintColor = Crypto.toolBar.barTintColor
        let doneButton = UIBarButtonItem(title: "Confirm Quantity", style: .done, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton, spaceButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {   }
    
}
