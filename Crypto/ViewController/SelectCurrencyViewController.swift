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

    @IBOutlet weak var currencyTextField: UITextField!{
        didSet {
            currencyTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var iconImageview: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!


    var code = ""
    var name = ""
    var icon = ""
    var delegate: SelectCurrencyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString, let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        
        return false
    }
    
    @objc func leftBarButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        if let text = currencyTextField.text {
            if !text.isEmpty {
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                self.navigationController?.view.layer.add(transition, forKey: kCATransition)
                _ = self.navigationController?.popViewController(animated: true)
                delegate?.showAlert(selectedCurrecny: code, changeTitle: navigationItem.title!)
            } else {
                alert(message: CryptoConstant.alertMessages.enterSomeValue)
            }
        }
    }
}

extension SelectCurrencyViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
            self.bottomSpacingConstraint.constant = 216
            UIView.animate(withDuration: ( notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval), animations: {
                self.view.layoutIfNeeded()
            })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.bottomSpacingConstraint.constant = 0
        UIView.animate(withDuration: ( notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval), animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension SelectCurrencyViewController: UITextFieldDelegate {
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? "1"
            UserDefaults.standard.set(text + " " + code + " " + "Equals", forKey: CryptoConstant.keys.price)
    }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
