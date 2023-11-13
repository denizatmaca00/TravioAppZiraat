//
//  AppAlertControl.swift
//  TravioApp
//
//  Created by Aydın Erol on 15.10.2023.
//

import UIKit
class AppAlertControl: UIAlertController {
    
   
}

extension UIViewController
{
    func showAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = AppAlertControl(title: title, message: message, preferredStyle: .alert)
        
        let btnCancel = UIAlertAction(title: "Kapat", style: .cancel) { _ in
            completion()
        }
        
        alert.addAction(btnCancel)
        
        self.present(alert, animated: true, completion: nil)
    }

}
