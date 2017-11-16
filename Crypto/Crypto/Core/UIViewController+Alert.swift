import Foundation
import UIKit

public extension UIViewController {
    
    struct AlertMessages {
        static let noInternetConnection = "No Internet connection available. Please connect to internet and try again."
    }
    
    func alert(message: String, title: String = "", OKAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: OKAction)
        
        alertController.addAction(OKAction)
        
        present(alertController, animated: true, completion: nil)
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
    
//    func noInternetMessage()  {
//        LoaderView.showMessage("Not connected to the internet please tap to open settings.", onView: view, isSearch: false) {
//            guard let urlString = URL(string:UIApplicationOpenSettingsURLString) else {return}
//            UIApplication.shared.openURL(urlString)
//        }
//    }
}
