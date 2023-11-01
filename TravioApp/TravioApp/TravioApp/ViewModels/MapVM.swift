//
//  MapVM.swift
//  TravioApp
//
//  Created by web3406 on 10/31/23.
//

import Foundation
import Alamofire
import CoreLocation
import UIKit
import MapKit

class MapVM {
    let map = MKMapView()
    
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

    
    func fetchAndShowPlaces() {
        self.fetchPlaces { result in
            switch result {
            case .success(let dataPlaces):
                let places = dataPlaces.data.places
                print("Toplam yer sayısı: \(places.count)")
                
                for place in places {
                    let title = place.title
                    let description = place.description
                    let latitude = place.latitude
                    let longitude = place.longitude

                    let annotation = CustomAnnotation(
                        title: title,
                        subtitle: description,
                        coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        logoImage: UIImage(named: "pinLogo")
                    )

                    self.map.addAnnotation(annotation)
                }
                
            case .failure(let error):
                print("Hata: \(error)")
            }
        }
    }
    
    func fetchPlacesCollectionView(completion: @escaping (Result<DataPlaces, Error>) -> Void) {
        NetworkingHelper.shared.dataFromRemote(urlRequest: .places) { (result: Result<DataPlaces, Error>) in
            switch result {
            case .success(let places):
                self.places = places.data.places
                completion(.success(places))
                print("12345")
                print(self.places)
                print("123456789")
                print(places)
            case .failure(let error):
                print("Hata oluştu: \(error)")
                completion(.failure(error))
            }
        }
    }

    
   
  


}

