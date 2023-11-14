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
    
    func uploadPhoto<T: Decodable>(images: [UIImage], urlRequest: Router, callback: @escaping Callback<T>) {
        var  imageDataArray: [Data] = []
        
        for image in images{
            guard let imageData = image.jpegData(compressionQuality: 1) else {continue}
            imageDataArray.append(imageData)
        }

        AF.upload(
            multipartFormData: { multipartFormData in
                for(index, imageData) in imageDataArray.enumerated(){
                    multipartFormData.append(imageData, withName: "file", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                }
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
