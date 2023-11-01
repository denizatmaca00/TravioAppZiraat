//
//  LoginVM.swift
//  TravioApp
//
//  Created by web3406 on 10/31/23.
//

import Foundation
import Alamofire

class LoginVM{
    
    var usersInfos: [Users] = []
    
    var showAlertClosure: ((String, String) -> Void)?

    func loginData(email: String?, password: String, completion: @escaping (Result<Tokens, Error>) -> Void) {
        let paramsPost = ["email": email, "password": password]

        NetworkingHelper.shared.dataFromRemote(urlRequest: .user(params: paramsPost)) { [self] (result: Result<Tokens, Error>) in
            switch result {
            case .success(let response):
                if response.accessToken != nil {
                    completion(.success(response))
                    KeychainHelper.shared.setToken(email: email! ,param: response)
                } else {
                    completion(.failure(NSError(domain: "Login Error", code: 401, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
