//
//  LoginVM.swift
//  TravioApp
//
//  Created by web3406 on 10/31/23.
//

import Foundation
import Alamofire

class LoginVM{
    
    var userInfo: User = User(full_name: "", email: "", password: "", id: "")
    
    var showAlertClosure: ((String, String) -> Void)?

    func sendLoginData(email: String?, password: String, completion: @escaping (Result<Tokens, Error>) -> Void) {
        let paramsPost = ["email": email, "password": password]

        NetworkingHelper.shared.dataFromRemote(urlRequest: .user(params: paramsPost)) { (result: Result<Tokens, Error>) in
            switch result {
                
            case .success(let response):
                    completion(.success(response))
                    KeychainHelper.shared.setToken(param: response)

            case .failure(let error):
                //completion(.failure(NSError(domain: "Login Error", code: 401, userInfo: nil)))
                completion(.failure(error))
            }
        }
    }
    
}
