//
//  NetworkVM.swift
//  TravioApp
//
//  Created by Ece Poyraz on 26.10.2023.
//

import Foundation
import Alamofire

class NetworkVM{
    
    var usersInfos: [Users] = []
    
    var showAlertClosure: ((String, String) -> Void)?

    
    func postUserData(name:String?,email:String?,password:String?){
       
        let paramsPost = ["full_name":name,
                          "email":email,
                          "password":password]
        
        NetworkingHelper.shared.dataFromRemote(urlRequest: .register(params: paramsPost), callback: { (result:Result<Users,Error>) in
            
            print(result)
        })
   
    }
    
    func getUserData(email: String, password: String, completion: @escaping (Result<Tokens, Error>) -> Void) {
        let paramsPost = ["email": email, "password": password]

        NetworkingHelper.shared.dataFromRemote(urlRequest: .user(params: paramsPost)) { [self] (result: Result<Tokens, Error>) in
            switch result {
            case .success(let response):
                if let accessToken = response.accessToken {
                    completion(.success(response))
                    KeychainHelper.shared.saveAccessToken(service: "Travio", account: "Deneme@gmail.com", token: response.accessToken!)
                    if let accessToken = KeychainHelper.shared.getToken(){
                        print("AccessToken: \(accessToken)")
                    } else {
                        print("AccessToken bulunamadı.")
                    }// okuman gereken yerde bunu alacaksın kontrol ederek

                } else {
                    completion(.failure(NSError(domain: "Login Error", code: 401, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    
    
    
}
