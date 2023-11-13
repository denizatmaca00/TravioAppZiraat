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
    
   // var editProfile: EditProfile = EditProfile(full_name: "", email: "", pp_url: "")

    var showAlertClosure: ((String, String) -> Void)?
    var reloadEditProfileClosure: ((EditProfile) -> Void)?
    
    
    
    func putEditProfileInfos(profile:EditProfile){
        let params = ["full_name": profile.full_name, "email": profile.email, "pp_url": "https://fotolifeakademi.com/uploads/2020/04/dusuk-isikta-fotograf-cekme-724x394.jpg"]

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
