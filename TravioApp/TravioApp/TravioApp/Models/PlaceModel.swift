//
//  PlaceModel.swift
//  TravioApp
//
//  Created by web3406 on 10/30/23.
//

import Foundation
import UIKit

struct VisitCellViewModel{
    var image:UIImage
    var placeName:String
    var city:String
}

struct VisitViewModel:Codable{
    var id:String
    var place_id:String
    var visited_at:String
    var created_at:String
    var updated_at:String
    var place:String
}

struct Visit:Codable {
    var id:String
    var place_id:String
    var visited_at:String
    var created_at:String
    var updated_at:String
}

struct Visits:Codable {
    var visits:[Visit]
}

struct Place: Codable {
    var id: String
    var creator: String
    var place: String
    var title: String
    var description: String
    var cover_image_url: String
    var latitude: Double
    var longitude: Double
    var created_at: String
    var updated_at: String
    
    
    init(id: String, creator: String, place: String, title: String, description: String, cover_image_url: String, latitude: Double, longitude: Double, created_at: String, updated_at: String) {
        self.id = id
        self.creator = creator
        self.place = place
        self.title = title
        self.description = description
        self.cover_image_url = cover_image_url
        self.latitude = latitude
        self.longitude = longitude
        self.created_at = created_at
        self.updated_at = updated_at
    }
}


struct PlacesData: Codable{
   
    var count: Int
    var places: [Place]
}
struct DataPlaces: Codable{
    var data: PlacesData
    var status: String
}

struct ReturnMessage:Codable {
    var message:String
    var status:String
}
