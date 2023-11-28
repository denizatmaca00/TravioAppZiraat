//
//  SecuritySettingsVM.swift
//  TravioApp
//
//  Created by Ece Poyraz on 15.11.2023.
//

import Foundation

class SecuritySettingsVM{
     
    var passwordChangeClosure: ((Password)->())?
    var passwordChangeAlertClosure: ((String,String)->Void)?
   
    func putPassword(password:Password){
        let passwordNew = ["new_password" : password.new_password]
        NetworkingHelper.shared.dataFromRemote(urlRequest: .putPassword(params: passwordNew), callback:{(result:Result<Messages,Error>) in
            switch result{
            case .success(let params):
                print(params)
                self.passwordChangeAlertClosure?("Password Change", "Password Change Success")
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        })
    }

}
