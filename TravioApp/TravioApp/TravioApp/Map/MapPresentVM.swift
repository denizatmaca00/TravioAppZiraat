//
//  MapPresentVM.swift
//  TravioApp
//
//  Created by web3406 on 11/13/23.
//

import Foundation
import UIKit

class MapPresentVM{
    
    var placeInfo: AddPlace = AddPlace(place: "", title: "", description: "", cover_image_url: "", latitude: 0, longitude: 0)

    var imageData:[UIImage] = []
    var imageURL:[String] = []{
        didSet{
            placeInfo.cover_image_url = imageURL.first!
        }
    }
    
    var isLoading:Bool = false {
        didSet{
            self.updateLoadingStatus?()
        }
    }
    
    // Closures
    var presentClosure:((UIImagePickerController)->Void)?
    var dismissClosure:(()->Void)?
   // var showAlertClosure: ((String, String) -> Void)?
    var updateLoadingStatus: ( ()->() )?
    
    func uploadPhoto(photo: UIImage) {
        let params = ["pp_url": photo]
        
        NetworkingHelper.shared.uploadPhoto(images: imageData, urlRequest: .uploadAddPhoto(params: params), callback: { (result: Result<AddPhotoUploadMultipartMessages, Error>) in
            switch result {
            case .success(let success):
                self.imageURL = success.urls
                
            case .failure(let failure):
                print("ERROR: \(failure)")
            }
        })
    }
    
    /// post place to API
    func postAddNewPlace(place: String?, title: String, description: String, cover_image_url: String,  latitude: Double, longitude: Double,completion: @escaping (Result<Messages, Error>) -> Void) {
        self.isLoading = true
        
        let paramsPost = ["place": place!, "title": title, "description": description, "cover_image_url": cover_image_url, "latitude" : latitude, "longitude": longitude] as [String : Any]

        NetworkingHelper.shared.dataFromRemote(urlRequest: .postAddPlace(params: paramsPost)) { (result: Result<Messages, Error>) in
            
            switch result {
                case .success(let response):
                    completion(.success(response))
                
                case .failure(let error):
                    completion(.failure(error))
            }
            self.isLoading = false
        }
    }
}
