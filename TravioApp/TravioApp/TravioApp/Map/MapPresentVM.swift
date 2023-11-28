//
//  MapPresentVM.swift
//  TravioApp
//
//  Created by web3406 on 11/13/23.
//

import UIKit

class MapPresentVM {
    
    var coordinator: MapPresentCoordinator?
    
    var placeInfo: AddPlace = AddPlace(place: "", title: "", description: "", cover_image_url: "", latitude: 0, longitude: 0)
    var placeId:String = ""{
        didSet{
            self.postGalleryImage()
        }
    }
    
    var picker: UIImagePickerController?
    var lastImage:UIImage?
    
    var imageURL:[String] = []{
        didSet{
            self.placeInfo.cover_image_url = self.imageURL.first!
            self.initPostPlace()
        }
    }
    
    var imageArray:[UIImage] = []
    
    /// Used to present and dismiss acitivity indicator during wait for server data
    var isLoading:Bool = false {
        didSet{
            self.updateLoadingStatus?(self.isLoading)
        }
    }
    
    // Closures
    var showAlertClosure: ((String, String) -> Void)?
    var reloadCollectionViewClosure: (()->())?
    var updateLoadingStatus: ( (Bool)->() )?
    var updateMapClosure: ( ()->Void )?
    var dismissClosure: (()->())?
    
    func fetchData(in cell:MapPresentCellVC, with indexPath:IndexPath){
        cell.fillCellWith(image: lastImage!)
    }
    
    /// Handles security processes required to save a place
    /// Uploads photos stored inside imageData
    func savePlace(){
        
        /// initial check for non-empty image data
        if imageArray.count > 0 {
                uploadPhoto()
        }else{
            
        }
    }
    
    private func uploadPhoto() {
        self.isLoading = true
        
        let params = ["file": ""] as [String : Any]
        
        NetworkingHelper.shared.uploadPhoto(images: imageArray, urlRequest: .uploadAddPhoto(params: params), callback: { (result: Result<AddPhotoUploadMultipartMessages, Error>) in
            
            switch result {
            case .success(let success):
                self.imageURL = success.urls
                
            case .failure(let error):
                self.showAlertClosure?("Error", "Photos couldn't be uploaded: \(error.localizedDescription)")
            }
            self.updateMapClosure?()
            self.isLoading = false
        })
    }
    
    private func initPostPlace(){
        postAddNewPlace(placeInfo: self.placeInfo, completion: { [weak self] result in
            switch result {
            case .success(let response):
                self?.placeId = response.message!
                
            case .failure(let error):
                self!.showAlertClosure?("Error", "Posting place failed with error: \(error.localizedDescription)")
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
               self.placeId = response.message!
                
            case .failure(let error):
                self.showAlertClosure?("Error", "Photos couldn't be uploaded to server: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }
    
    private func postGalleryImage(){
        
        for url in imageURL{
            let params = ["place_id": placeId, "image_url": url]
            
            NetworkingHelper.shared.dataFromRemote(urlRequest: .postGalleryImage(params: params), callback: { (result: Result<Messages, Error>) in
                switch result {
                case .success(_):
                    self.dismissClosure?()
                    
                case .failure(let error):
                    self.showAlertClosure?("Error", "Posting images: \(error.localizedDescription)")
                }
            })
        }
    }
}

// MARK: - Delegate PresentVC
extension MapPresentVM: MapPresentControllerDelegate {
    func didSuccessfullyAddPlace(){
        coordinator?.didAddPlace()
    }
}

