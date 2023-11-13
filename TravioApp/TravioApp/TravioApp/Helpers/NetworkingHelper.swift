//
//  NetworkingHelper.swift
//  TravioApp
//
//  Created by Ece Poyraz on 26.10.2023.
//

import Foundation
import Alamofire
import UIKit


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
    
    func uploadPhoto<T: Decodable>(image: UIImage, urlRequest: Router, callback: @escaping Callback<T>) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let conversionError = NSError(domain: "YourAppDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fotoğrafın veriye dönüştürülmesi başarısız oldu"])
            callback(.failure(conversionError))
            return
        }

        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                // Diğer gerekli verileri de ekleyebilirsiniz
            },
            to: urlRequest as! URLConvertible
        )
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let result):
                callback(.success(result))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    

}
