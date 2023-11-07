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

struct User: Codable {
    var full_name: String
    var email: String
    var password: String
    var id: String
}
struct EditProfile: Codable {
    var full_name: String
    var email: String
    var pp_url: String
}

struct Profile: Codable {
    var full_name: String
    var email: String
    var pp_url: String
    var role: String
    var created_at: String
}

struct Tokens: Codable {
    var accessToken: String
    var refreshToken: String
}

struct Messages: Codable {
    var message: String?
    var status: String?
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
