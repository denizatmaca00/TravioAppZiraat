//
//  SignUpVM.swift
//  TravioApp
//
//  Created by web3406 on 10/31/23.
//

import Foundation
import Alamofire

class SignUpVM{
    
    var isLoading:Bool = false {
        didSet{
            indicatorUpdateClosure?(self.isLoading)
        }
    }
    
    var showAlertClosure: ((String, String) -> Void)?
    
    var indicatorUpdateClosure:((Bool)->(Void))?

    func postUserData(name: String?, email: String?, password: String?, completion: @escaping (Result<Messages, Error>) -> Void) {
        let paramsPost = ["full_name": name, "email": email, "password": password]

        NetworkingHelper.shared.dataFromRemote(urlRequest: .register(params: paramsPost as Parameters)) { (result: Result<Messages, Error>) in
            
            switch result {
            case .success(let response):
                if let messages = response.message {
                    completion(.success(response))
                    self.showAlertClosure?("Notification", messages)
                } else {
                    completion(.failure(NSError(domain: "SignUp Error", code: 401, userInfo: nil)))

                }
            case .failure(let error):
                completion(.failure(error))
                self.showAlertClosure?("Error", error.localizedDescription)
            }
            self.isLoading = false

        }
    }
}
