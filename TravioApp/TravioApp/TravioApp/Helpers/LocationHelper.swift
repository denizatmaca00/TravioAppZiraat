//
//  LocationHelper.swift
//  TravioApp
//
//  Created by Aydın Erol on 12.11.2023.
//

import Foundation
import CoreLocation

class LocationHelper{
    
}

//unused backup helper method to get closest district/city name for given latitude:longitude coordinates
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
                cityArr.append(city)
                let cvm = VisitCellViewModel(image: URL(string: favorite.cover_image_url)!,
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
