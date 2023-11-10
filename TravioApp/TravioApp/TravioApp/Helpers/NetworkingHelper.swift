//
//  NetworkingHelper.swift
//  TravioApp
//
//  Created by Ece Poyraz on 26.10.2023.
//

import Foundation
import Alamofire


class NetworkingHelper {
    
    static let shared = NetworkingHelper()
    
    typealias Callback<T:Codable> = (Result<T,Error>)->Void
    
    public func dataFromRemote<T: Codable>(urlRequest: Router, callback: @escaping Callback<T>) {

        AF.request(urlRequest).validate().responseDecodable(of: T.self) { response in

            switch response.result {
            case .success(let success):
                callback(.success(success))
            case .failure(let failure):
                callback(.failure(failure))
                print(failure)

            }
        }
    }

}
