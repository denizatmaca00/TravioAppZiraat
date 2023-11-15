//
//  SecuritySettingsVM.swift
//  TravioApp
//
//  Created by Ece Poyraz on 15.11.2023.
//

import Foundation

class SecuritySettingsVM{
    
    //var paramsPassword:Password?
    var passwordChangeClosure: ((Password)->())?
   
    func putPassword(password:Password){
        let pass = ["new_password" : password.new_password]
        NetworkingHelper.shared.dataFromRemote(urlRequest: .putPassword(params: pass), callback:{(result:Result<Messages,Error>) in
            switch result{
            case .success(let params):
                print(params)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        })
    }
}