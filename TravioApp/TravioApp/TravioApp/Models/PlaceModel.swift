//
//  PlaceModel.swift
//  TravioApp
//
//  Created by web3406 on 10/30/23.
//

import Foundation
import UIKit

// MARK: Visits View Model

struct VisitCellViewModel{
    var image:URL
    var placeName:String
    var city:String
}

// MARK: Visit Structs

struct VisitsDataStatus: Codable{
    var data: VisitsData
    var status: String
}

struct VisitsData: Codable {
    var count: Int
    var visits: [Visit]
}

struct Visit: Codable {
    var id: String
    var place_id: String
    var visited_at: String
    var created_at: String
    var updated_at: String
    var place: Place
}


// MARK: Place Structs

struct PlacesDataStatus: Codable{
    var data: PlacesData
    var status: String
}

struct PlacesData: Codable{
    var count: Int
    var places: [Place]
}

struct Place: Codable {
    var id: String
    var creator: String
    var place: String
    var title: String
    var description: String
    var cover_image_url: String
    var latitude: Double?
    var longitude: Double?
    var created_at: String
    var updated_at: String
}

// MARK: Get Place By Id Response Model
struct PlaceIDDataStatus: Codable {
    var data: PlaceData
    var status: String
}

struct PlaceData: Codable {
    var place: Place
}

// MARK: Details View Model

struct DetailsCellViewModel{
    let desc:String
    let placeName:String
    let coordinates:String
}

//MARK: Get All Gallery by PlaceID
struct GalleryImage:Codable{
    var data: DataClass
    var status: String
}

struct DataClass:Codable{
    var images: [Image]
    var count: Int
}
struct Image:Codable{
    var id: String
    var place_id: String
    var image_url: String
    var created_at: String
    var updated_at: String
}

//MARK: Add Photo

struct AddPhotoUploadMultipartMessages: Codable {
    var messageType: String
    var message: String
    var urls: [String]
}

// MARK: Map add place post
struct AddPlace: Codable {
    var place: String
    var title: String
    var description: String
    var cover_image_url: String
    var latitude: Double
    var longitude: Double
}
