//
//  UserListViewModel.swift
//  MvvmBir
//
//  Created by web3406 on 10/23/23.
//

import Foundation
import Alamofire


class UserListViewModel {
    
    let vc = ShowUsersVC()
    var usersInfos: [User] = []

    public var cellViewModels: [User] = [] {
         didSet {
            reloadTableViewClosure?()
         }
     }
    
    var reloadTableViewClosure: (()->Void)?
    var showAlertClosure: (()->())?
    
    
    func getCellViewModel( at indexPath: IndexPath ) -> User {
            return cellViewModels[indexPath.row]
        }
        

    func getDataFromAPI(completion: @escaping (Result <[User], Error>) -> Void) {
            NetworkingHelper.shared.getDataFromRemote(urlRequest: .user) { (result: Result<[User], Error>) in
                switch result {
                case .success(let data):
                    self.usersInfos = data
                    completion(.success(data))
                    print(data)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    func postDataFromAPI(name: String?, email: String?, phoneNumber: String?, note: String?) {
        let paramsPost = [
            "name": name,
            "email": email,
            "phoneNumber": phoneNumber,
            "note": note
        ]
        
        NetworkingHelper.shared.getDataFromRemote(urlRequest: .register(params: paramsPost as Parameters)) { (result: Result<[User], Error>) in

            }
        }

}
