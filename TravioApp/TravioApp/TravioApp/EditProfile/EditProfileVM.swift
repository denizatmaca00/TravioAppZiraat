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
    
    // Struct and UI Properties
    var selectedImage:UIImage?
    var imageURL:String? {
        didSet{
            editProfile.pp_url = imageURL.last!
            putEditProfileInfos()
        }
    }
    
    // MARK: Public Functions
    
    func profileUpdated() {
        profileUpdateClosure?()
    }
    
    func postData(completion: (()->()) ) -> Void {
        
        if doUploadWork {
            editProfilePhotoUpload()
        }
        
        putEditProfileInfos()
    }
    
    // MARK: Private Functions
    private func editProfilePhotoUpload() -> Void {
        
        self.isLoading = true
        
        let params = ["pp_url": selectedImage]
        NetworkingHelper.shared.uploadPhoto(images: [selectedImage!], urlRequest: .uploadAddPhoto(params: params), callback: { (result: Result<AddPhotoUploadMultipartMessages, Error>) in
            switch result {
            case .success(let success):
                self.imageURL = success.urls.first
                
            case .failure(_):
                self.doUploadWork = true
            }
            self.isLoading = false
        })
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
