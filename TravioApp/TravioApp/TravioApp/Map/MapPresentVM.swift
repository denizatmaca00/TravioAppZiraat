//
//  MapPresentVM.swift
//  TravioApp
//
//  Created by web3406 on 11/13/23.
//

import Foundation

class MapPresentVM{
    //AddPlace
   // var userInfo: LoginUser = LoginUser(email: "", password: "")
    var addPlaceInfo: AddPlace = AddPlace(place: "", title: "", description: "", cover_image_url: "", latitude: 0, longitude: 0)
    var isLoading:Bool = false {
        didSet{
            self.updateLoadingStatus?()
        }
    }
    
   // var showAlertClosure: ((String, String) -> Void)?
    
    var updateLoadingStatus: ( ()->() )?
    
    func postAddNewPlace(place: String?, title: String, description: String, cover_image_url: String,  latitude: Double, longitude: Double,completion: @escaping (Result<Messages, Error>) -> Void) {
        self.isLoading = true
        
        let paramsPost = ["place": place!, "title": title, "description": description, "cover_image_url": cover_image_url, "latitude" : latitude, "longitude": longitude] as [String : Any]

        NetworkingHelper.shared.dataFromRemote(urlRequest: .postAddPlace(params: paramsPost)) { (result: Result<Messages, Error>) in
            self.isLoading = false
            switch result {
                case .success(let response):
                    completion(.success(response))
                print("başraılı")
                case .failure(let error):
                print("hatahata")

                    completion(.failure(error))
            }
        }
    }
}
