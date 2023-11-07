//
//  EditProfileVM.swift
//  TravioApp
//
//  Created by web3406 on 11/7/23.
//

import Foundation
import Alamofire
import UIKit

class EditProfileVM {
    
    var editProfile: [EditProfile] = []
    
    var showPinClosure: (() -> Void)?
    var showAlertClosure: ((String, String) -> Void)?
    var reloadEditProfileClosure: (()->())?
    
    private var cellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadEditProfileClosure?()
        }
    }
    
    func getEditProfileInfos(completion: @escaping (Result<[EditProfile], Error>) -> Void) {
        NetworkingHelper.shared.dataFromRemote(urlRequest: .putEditProfile) { (result: Result<[EditProfile], Error>) in
            switch result {
            case .success(let profile):
                self.editProfile = profile
                completion(.success(profile))
                print(profile)
            case .failure(let error):
                print("Hata oluştu: \(error)")
                completion(.failure(error))
            }
        }
    }
}

