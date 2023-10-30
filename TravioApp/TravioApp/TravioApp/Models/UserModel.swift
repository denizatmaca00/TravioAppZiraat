//
//  UserModel.swift
//  TravioApp
//
//  Created by Ece Poyraz on 26.10.2023.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

struct Users:Codable {
    
    var full_name:String
    var email:String
    var password: String
    var id:String
}
struct Tokens: Codable {
    var accessToken: String?
    var refreshToken: String?
}

class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var logoImage: UIImage?
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, logoImage: UIImage?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.logoImage = logoImage
        super.init()
    }
}
