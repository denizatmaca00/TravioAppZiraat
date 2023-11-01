//
//  VisitsViewModel.swift
//  TravioApp
//
//  Created by Aydın Erol on 27.10.2023.
//

import Foundation
import UIKit
import CoreLocation

class VisitsVM{
    
    private var favorites: [Place] = []
    
    private var cellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var numberOfCells:Int {
        return cellViewModels.count
    }
    
    // this will be filled on VisitsVC to populate tableView with updated data
    var reloadTableViewClosure: (()->())?
    
    func initFetch(){
        // here places will be fetchED from the server using .visits for VisitsVC and will be used to fill favorites:[Place/Visit] array
        
        NetworkingHelper.shared.dataFromRemote(urlRequest: .places) { [weak self] (result:Result<DataPlaces, Error>) in
            
            switch result {
            case .success(let data):
                self?.fetchVisits(favorites: data.data.places )
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    // MARK: Create View Model
    
    private func fetchVisits(favorites:[Place]){
        self.favorites = favorites
        
        var viewModels = [VisitCellViewModel]()
        
        for favorite in favorites {
            viewModels.append(createCellViewModel(favorite: favorite))
        }
        
        self.cellViewModels = viewModels
    }
    
    private func createCellViewModel(favorite:Place) -> VisitCellViewModel{
        // converts info contained in "MyVisits" and adapts to CellViewModel for each VisitCell to show inside each vistsCell
        
        let cvm = VisitCellViewModel(image: UIImage(named: "sultanahmet")!,
                                     placeName: favorite.title,
                                     city: favorite.place)
        return cvm
    }
    
    func getCellViewModel(at indexPath:IndexPath)->VisitCellViewModel{
        return cellViewModels[indexPath.row]
    }
}

extension VisitsVM {
    // This function can be used to create cellView with city data obtained by Lat:Long data in favorites array
    private func setCellViewByLatLong(favorite:Place){
        var cityArr:[String] = []
        var viewModels = [VisitCellViewModel]()
        
        let location = CLLocation(latitude: favorite.latitude, longitude: favorite.longitude)
        var city:String = "nilDefault"
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks , error in
            
            if error == nil && placemarks!.count > 0 {
                guard let placemark = placemarks?.last else {
                    return
                }
                city = placemark.locality ?? " "
                print("ekledim içeriden \(city)")
                cityArr.append(city)
                let cvm = VisitCellViewModel(image: UIImage(named: "sultanahmet")!,
                                             placeName: favorite.title,
                                             city: city)
                viewModels.append(cvm)
                self.cellViewModels = viewModels
            }
            if city != "nilDefault"{
                cityArr.append(city)
            }
        }
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct VisitsVM_Preview: PreviewProvider {
    static var previews: some View{
        
        VisitsVC().showPreview()
    }
}
#endif
