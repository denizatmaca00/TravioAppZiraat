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
                KeychainHelper.shared.setToken(param: response)
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        if KeychainHelper.shared.isUserLoggedIn() {
            // Kullanıcı oturum açık ise logout işlemini gerçekleştirsin
            KeychainHelper.shared.delete("Travio", account: "asd")
            // userToken değişkenini günceller
            KeychainHelper.shared.userToken = Tokens(accessToken: "", refreshToken: "")
            completion(.success(()))
        } else {
            // Kullanıcı zaten oturum açık değilse hata döndür
            let error = NSError(domain: "Logout Error", code: 401, userInfo: nil)
            print("zaten açık değil")
            completion(.failure(error))
        }
    }
    
}