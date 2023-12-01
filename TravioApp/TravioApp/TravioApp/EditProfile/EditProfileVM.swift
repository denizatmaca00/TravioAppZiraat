//
//  EditProfileVM.swift
//  TravioApp
//
//  Created by web3406 on 11/7/23.
//
//

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
    var doUploadWork:Bool = false
    
    // Closures
    var profileUpdateClosure: (() -> Void)?
    var indicatorUpdateClosure:((Bool, String?)->(Void))?
    var showAlertClosure: ((String, String) -> Void)?
    
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
            self.indicatorUpdateClosure?(true, "Updating profile picture.")
            let params = ["pp_url": self.selectedImage]
            
            dispatchGroup.enter()
            NetworkingHelper.shared.uploadPhoto(images: [self.selectedImage!], urlRequest: .uploadAddPhoto(images: [self.selectedImage!]), callback: { (result: Result<AddPhotoUploadMultipartMessages, Error>) in
                switch result {
                case .success(let success):
                    self.imageURL = success.urls.first
                    self.editProfile.pp_url = self.imageURL!
                    self.doUploadWork = false
                    
                case .failure(_):
                    self.doUploadWork = true
                    
                }
                self.dispatchGroup.leave()
                self.indicatorUpdateClosure?(false, nil)
            })
        }
    }
    
    private func putEditProfileInfos() -> Void {
        
        self.indicatorUpdateClosure?(true, "Updating user profile.")
        
        dispatchGroup.enter()
        let params = ["full_name": editProfile.full_name, "email": editProfile.email, "pp_url": editProfile.pp_url]
        NetworkingHelper.shared.dataFromRemote(urlRequest: .putEditProfile(params: params), callback: {  (result: Result<Messages, Error>) in
            switch result {
            case .success(_):
                self.showAlertClosure?("Notification", "Updated profile successfully.")
            case .failure(_):
                self.showAlertClosure?("Error", "Failed to update profile.")
            }
            self.dispatchGroup.leave()
            self.indicatorUpdateClosure?(false, nil)
        })
    }
}
