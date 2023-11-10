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
    var reloadEditProfileClosure: ((EditProfile) -> Void)?
    
    
    
    func changeProfileInfo(profile:EditProfile){
        let params = ["full_name": profile.full_name, "email": profile.email, "pp_url": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.imdb.com%2Fname%2Fnm0000093%2Fbio%2F&psig=AOvVaw2AS0FsBGFMAbPecZTs4FUR&ust=1699359812146000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNCJieKur4IDFQAAAAAdAAAAABAE"]

        NetworkingHelper.shared.dataFromRemote(urlRequest: .putEditProfile(params: params), callback: { (result: Result<Messages, Error>) in
            switch result {
            case .success(let success):
                print(params)
                print("Başarılı yanıt: \(success)")
            case .failure(let failure):
                print("Başarısız yanıt: \(failure)")
            }
        })

    }

    
    
//    func getEditProfileInfos(full_name: String, email: String, pp_url: String, completion: @escaping (Result<Messages, Error>) -> Void)  {
//        let paramsPut = ["full_name": full_name, "email": email, "pp_url": pp_url]
//
//        NetworkingHelper.shared.dataFromRemote(urlRequest: .putEditProfile(params: paramsPut)) { (result: Result<Messages,Error>) in
//            print("result in dataMessages-getEdit: \(result)")
//            switch result {
//            case .success(let profile):
//                //self.editProfile = profile
//                //self.reloadEditProfileClosure?(profile)
//                self.showAlertClosure?("Success", "Profile updated successfully.") // Başarı durumu
//                completion(.success(profile))
//            case .failure(let error):
//                print("Hata oluştu in getEditProfile: \(error)")
////                self.showAlertClosure?("Error", "Profile update failed.") // Hata durumu
//                completion(.failure(error))
//                print("sdjfjnfjn")
//                print(paramsPut)
//            }
//        }
//    }

}