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
    var reloadTableViewClosure: (()->())?
    
    private var cellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    func fetchPlaces(completion: @escaping (Result<PlacesDataStatus, Error>) -> Void) {
        NetworkingHelper.shared.dataFromRemote(urlRequest: .places) { (result: Result<PlacesDataStatus, Error>) in
            switch result {
            case .success(let places):
                self.places = places.data.places
                
                if let firstPlace = self.places.first {
                    // Eğer yer varsa, haritayı ilk yerin koordinatlarına odaklıcak burası
                    let coordinate = CLLocationCoordinate2D(latitude: firstPlace.latitude, longitude: firstPlace.longitude)
                    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                    self.map.setRegion(region, animated: true)
                }
                
                completion(.success(places))
            case .failure(let error):
                print("Hata oluştu: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchPlacesForCollectionCell(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: .places) { [weak self] (result:Result<PlacesDataStatus, Error>) in
            switch result {
            case .success(let data):
                self?.fetchVisits(favorites: data.data.places )
            case .failure(let failure):
                print(failure.localizedDescription)
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
    
    private func fetchVisits(favorites:[Place]){
        self.places = favorites
        
        var viewModels = [VisitCellViewModel]()
        
        for favorite in favorites {
            viewModels.append(createCellViewModel(favorite: favorite))
        }
        
        self.cellViewModels = viewModels
    }
    
    private func createCellViewModel(favorite:Place) -> VisitCellViewModel{
        let cvm = VisitCellViewModel(image: URL(string: favorite.cover_image_url)!,
                                     placeName: favorite.title,
                                     city: favorite.place)
        return cvm
    }
    
    func getCellViewModel(at indexPath:IndexPath)->VisitCellViewModel{
        return cellViewModels[indexPath.row]
    }
    
    func tappedCellMap(at indexPath:IndexPath){
        let latitude = places[indexPath.row].latitude
        let longitude = places[indexPath.row].longitude
        let coordinate = MKCoordinateRegion.init(center: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude), span: MKCoordinateSpan.init())
        map.setRegion(coordinate, animated: true)
    }
}
