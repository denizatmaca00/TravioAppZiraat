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
        
        let btnCancel = UIAlertAction(title: "Dismiss", style: .cancel) { _ in
            completion()
        }
        
        alert.addAction(btnCancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addActionSheet(deleteAction: @escaping () -> Void) {
           let actionSheet = UIAlertController(title: "Choose the action", message: "Tap the action you want to take.", preferredStyle: .actionSheet)

           let deleteAction = UIAlertAction(title: "Delete the Location I Added", style: .destructive) { _ in
               deleteAction() 
           }

           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

           actionSheet.addAction(deleteAction)
           actionSheet.addAction(cancelAction)

           present(actionSheet, animated: true, completion: nil)
       }
}
