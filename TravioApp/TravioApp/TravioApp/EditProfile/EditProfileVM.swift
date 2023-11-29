//
//  EditProfileVM.swift
//  TravioApp
//
//  Created by web3406 on 11/7/23.
//
//

import Foundation
import Alamofire
import UIKit

class EditProfileVM {
    
    // MARK: Properties
    
    // Struct-Related
    var editProfile: EditProfile = EditProfile(full_name: "", email: "", pp_url: "")
    var profile: Profile? {
        didSet {
            profileUpdateClosure?()
        }
    }
    
    // Flags
    var isLoading:Bool = false {
        didSet{
            indicatorUpdateClosure?(self.isLoading)
        }
    }
    var doUploadWork:Bool = false
    
    // Closures
    var profileUpdateClosure: (() -> Void)?
    var indicatorUpdateClosure:((Bool)->(Void))?
    var showAlertClosure: ((String, String) -> Void)?
    var reloadEditProfileClosure: (() -> ())?
    
    // UI Properties
    var selectedImage:UIImage?
    var imageURL:String?
    
    // Dispatch Items
    let dispatchGroup = DispatchGroup()
    
    // MARK: Public Functions
    
    func postData() -> Void {
        /// initiate image upload if any image is given via imagePicker
        self.editProfilePhotoUpload()
        
        /// wait for imageURL to be filled
        dispatchGroup.notify(queue: .main){
            /// post profile data when previous tasks in group are completed.
            self.putEditProfileInfos()
        }
    }
    
    // MARK: Private Functions
    
    private func editProfilePhotoUpload() -> Void {
        if doUploadWork {
            
            self.isLoading = true
            let params = ["pp_url": self.selectedImage]
            
            dispatchGroup.enter()
            NetworkingHelper.shared.uploadPhoto(images: [self.selectedImage!], urlRequest: .uploadAddPhoto(params: params as Parameters), callback: { (result: Result<AddPhotoUploadMultipartMessages, Error>) in
                switch result {
                case .success(let success):
                    self.imageURL = success.urls.first
                    self.editProfile.pp_url = self.imageURL!
                    self.doUploadWork = false
                    
                case .failure(_):
                    self.doUploadWork = true
                    
                }
                self.dispatchGroup.leave()
                self.isLoading = false
            })
        }
    }
    
    private func putEditProfileInfos() -> Void {
        
        self.isLoading = true
        let params = ["full_name": editProfile.full_name, "email": editProfile.email, "pp_url": editProfile.pp_url]
        
        NetworkingHelper.shared.dataFromRemote(urlRequest: .putEditProfile(params: params), callback: {  (result: Result<Messages, Error>) in
            switch result {
            case .success(_):
                self.showAlertClosure?("Notification", "Updated profile successfully.")
                
            case .failure(_):
                self.showAlertClosure?("Error", "Failed to update profile.")
                
            }
            self.isLoading = false
        })
    }
}
