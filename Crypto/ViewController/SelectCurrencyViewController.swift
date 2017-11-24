//
//  SelectCurrencyViewController.swift
//  Crypto
//
//  Created by Crownstack on 16/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

import UIKit

protocol SelectCurrencyDelegate: class {
    func showAlert(selectedCurrecny: String, changeTitle: String)
}

class SelectCurrencyViewController: UIViewController,UIToolbarDelegate {

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
        navigationItem.title = "Convert \(code) to..."
        navigationItem.leftBarButtonItem = CryptoNavigationBar.backButton(self, action: #selector(leftBarButtonAction(_:)))
        nameLabel.text = name
        codeLabel.text = code
        if verifyUrl(urlString: icon) {
            iconImageview.loadImageUsingCache(withUrl: icon)
        } else {
            iconImageview.image = UIImage(named: icon)
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString, let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        
        return false
    }
    
    @objc func leftBarButtonAction(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 55)
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Crypto.toolBar.tintColor
        toolBar.barTintColor = Crypto.toolBar.barTintColor
        let doneButton = UIBarButtonItem(title: Crypto.title.toolBarButtonTitle, style: .done, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton, spaceButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        view.endEditing(true)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popViewController(animated: true)
        delegate?.showAlert(selectedCurrecny: code, changeTitle: navigationItem.title!)
    }
}

extension SelectCurrencyViewController: UITextFieldDelegate {
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? "1"
            UserDefaults.standard.set(text + " " + code + " " + "Equals", forKey: "price")
    }
}
