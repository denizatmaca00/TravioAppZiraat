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
    
    func addActionSheet(deleteAction: @escaping () -> Void) {
           let actionSheet = UIAlertController(title: "Seçim Yap", message: "Yapmak istediğiniz işleme dokunun.", preferredStyle: .actionSheet)

           let deleteAction = UIAlertAction(title: "Eklediğim Konumu Sil", style: .destructive) { _ in
               deleteAction() 
           }

           let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel)

           actionSheet.addAction(deleteAction)
           actionSheet.addAction(cancelAction)

           present(actionSheet, animated: true, completion: nil)
       }
}
