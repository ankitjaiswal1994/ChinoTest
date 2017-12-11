import Foundation
import UIKit
import SwiftyStoreKit

public extension UIViewController {
    
    struct AlertMessages {
        static let noInternetConnection = "No Internet connection available. Please connect to internet and try again."
    }
    
    func alert(message: String, title: String = "", OKAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: OKAction)
        alertController.addAction(OKAction)
        dispatch {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func alertWithTwoAction(message: String, title: String = "", OkButtonTitle: String = "", cancelButtonTitle: String = "", OKAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: OkButtonTitle, style: .default, handler: OKAction)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alertNoInternetConnection() {
        alert(message: AlertMessages.noInternetConnection)
    }
    
    func noInternetMessage()  {
        LoaderView.showMessage("Not connected to the internet please tap to open settings.", onView: view, isSearch: false) {
            guard let urlString = URL(string:UIApplicationOpenSettingsURLString) else {return}
            UIApplication.shared.openURL(urlString)
        }
    }
    
    func inAppPurchaseAlert() {
        
        let message = """
    UPGRADE
    - Unlimted cryptocurrency-to-cryptocurrency converstions
    - Unlimted common currency-to-common currency converstions
    - Unlimted common currency to cryptocurrency converstions

    100% Free Peace of Mind

    30-day free trial.
    $39.99 yearly auto-renewing subsciption after your trial unless turned off, cancel anytime in account settings. Cost & protection of renewal is equal to initial subsciption. Go to bit.ly/dvapp for full details
    """
        
        alertWithTwoAction(message: message, title: "UNLIMITED CONVERSIONS", OkButtonTitle: "Turn On", cancelButtonTitle: "Disable") { (action) in
            SwiftyStoreKit.purchaseProduct("11212017", quantity: 1, atomically: true) { result in
                switch result {
                case .success(let purchase):
                    print("Purchase Success: \(purchase.productId)")
                case .error(let error):
                    switch error.code {
                    case .unknown: print("Unknown error. Please contact support")
                    case .clientInvalid: print("Not allowed to make the payment")
                    case .paymentCancelled: break
                    case .paymentInvalid: print("The purchase identifier was invalid")
                    case .paymentNotAllowed: print("The device is not allowed to make the payment")
                    case .storeProductNotAvailable: print("The product is not available in the current storefront")
                    case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                    case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                    case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                    }
                }
            }
        }
    }
}
