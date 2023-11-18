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
    
    var picker: UIImagePickerController?
    var lastImage:UIImage?
    
    var imageURL:[String] = []{
        didSet{
            self.placeInfo.cover_image_url = self.imageURL.first!
            self.initPostPlace()
        }
    }
    
    var imageData:[UIImage] = []
    
    /// Used to present and dismiss acitivity indicator during wait for server data
    var isLoading:Bool = false {
        didSet{
            self.updateLoadingStatus?(self.isLoading)
        }
    }
    
    // Closures
    // var showAlertClosure: ((String, String) -> Void)?
    var reloadCollectionViewClosure: (()->())?
    var updateLoadingStatus: ( (Bool)->() )?
    var updateMapClosure: ( ()->Void )?
    var dismissClosure: (()->())?
    
    func fetchData(in cell:MapPresentCellVC, with indexPath:IndexPath){
        cell.fillCellWith(image: lastImage!)
    }
    
    /// Handles processes required to save a place
    /// Uploads photos stored inside imageData
    /// Using
    func savePlace(){
        
        /// initial check for non-empty image data
        if imageData.count > 0 {
                /// upload photo
                for photo in [imageData[0]]{
                    uploadPhoto(photo: photo)
                }
        }else{
            print("No images found")
        }
    }
    
    private func uploadPhoto(photo: UIImage) {
        self.isLoading = true
        
        let params = ["image_url": photo]
        
        NetworkingHelper.shared.uploadPhoto(images: imageData, urlRequest: .uploadAddPhoto(params: params), callback: { (result: Result<AddPhotoUploadMultipartMessages, Error>) in
            switch result {
            case .success(let success):
                self.imageURL = success.urls
                print("URL:: \(success.urls)")
            case .failure(let failure):
                print("ERROR: \(failure)")
            }
            self.isLoading = false
        })
    }
    
    private func initPostPlace(){
        postAddNewPlace(placeInfo: self.placeInfo, completion: { [weak self] result in
            switch result {
            case .success(let response):
                if let messages = response.message {
                    self!.dismissClosure?()
                    self!.updateMapClosure?()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        })
    }
    
    /// post place to API
    private func postAddNewPlace(placeInfo:AddPlace ,completion: @escaping (Result<Messages, Error>) -> Void) {
        self.isLoading = true
        
        let paramsPost = ["place": placeInfo.place, "title": placeInfo.title, "description": placeInfo.description, "cover_image_url": placeInfo.cover_image_url, "latitude" : placeInfo.latitude, "longitude": placeInfo.longitude] as [String : Any]
        
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
//    private func updatePlace(placeInfo:AddPlace ,completion: @escaping (Result<Messages, Error>) -> Void) {
//        self.isLoading = true
//        
//        let paramsPost = ["place": placeInfo.place, "title": placeInfo.title, "description": placeInfo.description, "cover_image_url": placeInfo.cover_image_url, "latitude" : placeInfo.latitude, "longitude": placeInfo.longitude] as [String : Any]
//        
//        NetworkingHelper.shared.dataFromRemote(urlRequest: .postAddPlace(params: paramsPost)) { (result: Result<Messages, Error>) in
//            
//            switch result {
//            case .success(let response):
//                completion(.success(response))
//                
//            case .failure(let error):
//                completion(.failure(error))
//            }
//            self.isLoading = false
//        }
//    }
}
