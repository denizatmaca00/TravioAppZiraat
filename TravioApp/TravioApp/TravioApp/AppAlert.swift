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
    func showAlert(title:String, message:String)
    {
        DispatchQueue.main.async{
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let btnCancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(btnCancel)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
