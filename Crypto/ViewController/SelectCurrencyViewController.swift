//
//  SelectCurrencyViewController.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit

protocol SelectCurrencyDelegate: class {
    func showAlert()
}

class SelectCurrencyViewController: UIViewController {

    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var iconImageview: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    var code = ""
    var name = ""
    var icon = ""
    var delegate: SelectCurrencyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addToolBar(textField: currencyTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currencyTextField.becomeFirstResponder()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = Crypto.navigationTitle.selectCurrency
        navigationItem.leftBarButtonItem = CryptoNavigationBar.backButton(self, action: #selector(leftBarButtonAction(_:)))
        nameLabel.text = name
        codeLabel.text = code
        iconImageview.image = UIImage(named: icon)
    }
    
    @objc func leftBarButtonAction(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
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
    
    @objc func donePressed() {
        navigationController?.popViewController(animated: true)
        delegate?.showAlert()
    }
}

extension SelectCurrencyViewController: UITextFieldDelegate {
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        UserDefaults.standard.set(text + " " + code + " " + "Equals", forKey: "price")
    }
}
