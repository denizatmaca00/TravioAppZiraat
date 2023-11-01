//
//  MapVM.swift
//  TravioApp
//
//  Created by web3406 on 10/31/23.
//

import Foundation
import Alamofire

class MapVM {
    
    
    var places: [Place] = []
    
    var showPinClosure: (() -> Void)?
    var showAlertClosure: ((String, String) -> Void)?

    
    func fetchPlaces(completion: @escaping (Result<DataPlaces, Error>) -> Void) {
        NetworkingHelper.shared.dataFromRemote(urlRequest: .places) { (result: Result<DataPlaces, Error>) in
            switch result {
            case .success(let places):
                self.places = places.data.places
                completion(.success(places))
            case .failure(let error):
                print("Hata oluştu: \(error)")
                completion(.failure(error))
            }
        }
    }


}

