//
//  ProfileVM.swift
//  TravioApp
//
//  Created by web3406 on 11/7/23.
//

import Foundation

class ProfileVM {
    
    var profile: Profile = Profile(full_name: "", email: "", pp_url: "", role: "", created_at: "")
    
    var profileUpdateClosure: ((Profile) -> Void)?
    weak var editProfileVC: EditProfileVC?

    func getProfileInfos(completion: @escaping (Result<Profile, Error>) -> Void) {
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getProfile) { (result: Result<Profile, Error>) in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.profileUpdateClosure?(profile)
                completion(.success(profile))
//                self.editProfileVC?.updateUI(with: profile)
                print(profile)
            case .failure(let error):
                print("Hata oluştu: \(error)")
                completion(.failure(error))
            }
        }
    }
}

