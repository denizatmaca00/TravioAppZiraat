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

// Helper method to get closest district/city name for given latitude:longitude coordinates
extension MapPresentVC {
    // This function can be used to create cellView with city data obtained by Lat:Long data in favorites array
    func getLocalName(latitude:Double, longitude:Double){
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks , error in
            
            if error == nil && placemarks!.count > 0 {
                guard let placemark = placemarks?.last else {
                    return
                }
                let city = placemark.locality ?? " "
                if let country = placemark.country {
                    self.localName = "\(country), \(city)"
                } else{
                    self.localName = "\(city)"
                }
            }
        }
    }
}
