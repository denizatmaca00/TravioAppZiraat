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
    
    var editProfile: EditProfile = EditProfile(full_name: "", email: "", pp_url: "")

    var showAlertClosure: ((String, String) -> Void)?
    var reloadEditProfileClosure: (() -> ())?
    var imagesDatas:[UIImage] = []
    var imageURL:[String] = []{
        didSet{
            editProfile.pp_url = imageURL.first!
            putEditProfileInfos()
        }
    }

    func editProfilePhotoUpload(photo: UIImage){
        let params = ["pp_url": photo]
        NetworkingHelper.shared.uploadPhoto(images: imagesDatas, urlRequest: .uploadAddPhoto(params: params), callback: { (result: Result<AddPhotoUploadMultipartMessages, Error>) in
            switch result {
            case .success(let success):
                self.imageURL = success.urls
                
                self.imageURL = success.urls
            case .failure(let failure):
                print("Başarısız yanıt: \(failure)")
            }
        })
    }

    
    func putEditProfileInfos(){
        let params = ["full_name": editProfile.full_name, "email": editProfile.email, "pp_url": editProfile.pp_url]
        NetworkingHelper.shared.dataFromRemote(urlRequest: .putEditProfile(params: params), callback: { (result: Result<Messages, Error>) in
            switch result {
            case .success(let success):
                print(params)
                self.showAlertClosure?("Notification", "Update Successful")
                print("Başarılı yanıt: \(success)")
            case .failure(let failure):
                self.showAlertClosure?("Error", "Update Unssuccessful")

                print("Başarısız yanıt: \(failure)")
            }
        })

    }
    

    
}
