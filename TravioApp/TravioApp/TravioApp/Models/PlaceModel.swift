//
//  PlaceModel.swift
//  TravioApp
//
//  Created by web3406 on 10/30/23.
//

import Foundation
import UIKit

struct VisitCellViewModel{
    let image:UIImage
    let placeName:String
    let city:String
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

struct Places:Codable {
    var places:[Place]
}

struct Place:Codable {
    var id:String
    var creator:String
    var place:String
    var title:String
    var description:String
    var cover_image_url:String
    var latitude:Double
    var longitude:Double
    var created_at:String
    var updated_at:String
}

struct ReturnMessage:Codable {
    var message:String
    var status:String
}
