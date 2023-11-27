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
    var reloadCollectionViewClosure: (()->())?
    
    private var cellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadCollectionViewClosure?()
        }
    }
    
    func fetchPlaces(completion: @escaping (Result<PlacesDataStatus, Error>) -> Void) {
        NetworkingHelper.shared.dataFromRemote(urlRequest: .places) { (result: Result<PlacesDataStatus, Error>) in
            switch result {
            case .success(let places):
                self.places = places.data.places
                
                if let firstPlace = self.places.first {
                    let coordinate = CLLocationCoordinate2D(latitude: firstPlace.latitude, longitude: firstPlace.longitude)
                    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                     self.map.setRegion(region, animated: true)
                }
                
                completion(.success(places))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPlacesForCollectionCell(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: .places) { [weak self] (result:Result<PlacesDataStatus, Error>) in
            switch result {
            case .success(let data):
                self?.fetchVisits(mapPlaces: data.data.places )
            case .failure(_):
                break
            }
        }
    }
    func addCustomAnnotation(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, logoImage: UIImage?) {
        let annotation = CustomAnnotation(
            title: title,
            subtitle: subtitle,
            coordinate: coordinate,
            logoImage: logoImage
        )
        
        map.addAnnotation(annotation)
    }
    
    func fetchAndShowPlaces() {
        self.fetchPlaces { result in
            switch result {
            case .success(let dataPlaces):
                let places = dataPlaces.data.places
                
                for place in places {
                    let title = place.title
                    let description = place.description
                    let latitude = place.latitude
                    let longitude = place.longitude
                    self.addCustomAnnotation(title: title, subtitle: description, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), logoImage:UIImage(named: "pinLogo"))
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func fetchVisits(mapPlaces:[Place]){
        self.places = mapPlaces
        
        var viewModels = [VisitCellViewModel]()
        
        for mapPlace in mapPlaces {
            viewModels.append(createCellViewModel(mapPlace: mapPlace))
        }
        
        self.cellViewModels = viewModels
    }
    
    private func createCellViewModel(mapPlace:Place) -> VisitCellViewModel{
        let cvm = VisitCellViewModel(image: URL(string: mapPlace.cover_image_url)!,
                                     placeName: mapPlace.title,
                                     city: mapPlace.place)
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
