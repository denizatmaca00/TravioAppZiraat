//
//  VisitsViewModel.swift
//  TravioApp
//
//  Created by Aydın Erol on 27.10.2023.
//

import Foundation
import UIKit

class VisitsViewModel{
    
    // dummy data for tableView
    private var favorites: [Place] = [Place(id: "1", creator: "Avni", place: "Colloseo", title: "KolezyumBaşlık", description: "Kolezyuma gittim geldim falan", cover_image_url: "https://myimage.com/colosseum", latitude: 27.232323, longitude: 15.35215, created_at: "2023-10-28", updated_at: "2023-10-28"),
                                      Place(id: "1", creator: "Mehmet", place: "Ayasofya", title: "AyasofyaBaşlık", description: "Ayasofya'da 2 rekat kıldım gittim geldim falan", cover_image_url: "https://myimage.com/hagiasophia", latitude: 23.232323, longitude: 17.35215, created_at: "2023-10-28", updated_at: "2023-10-28")]
    
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
        // here places will be fetch from the server using .visits for VisitsVC and will be used to fill favorites:[Place/Visit] array
        //let postParams = ["id": 1]
//        NetworkingHelper.shared.dataFromRemote(urlRequest: .visits) { [weak self] (result:Result<Place, Error>) in
//            print(result)
//            self?.fetchVisits(favorites: self?.favorites ?? [])
//        }
        fetchVisits(favorites: favorites)
    }
    
    // MARK: Create View Model
    
    private func fetchVisits(favorites:[Place]){
        self.favorites = favorites
        
        var viewModels = [VisitCellViewModel]()
        
        for favorite in favorites {
            viewModels.append( createCellViewModel(favorite: favorite))
        }
        self.cellViewModels = viewModels
    }
    
    private func createCellViewModel(favorite:Place) -> VisitCellViewModel{
        // converts info contained in "MyVisits" and adapts to CellViewModel for each VisitCell
        
        // here favorite.place_id 's are placeholders, a function should take place_id and convert into placeName and placeCity.
        let cvm = VisitCellViewModel(image: UIImage(named: "deneme")!, 
                                     placeName: favorite.place,
                                     city: favorite.creator)
        return cvm
    }
    
    func getCellViewModel(at indexPath:IndexPath)->VisitCellViewModel{
        return cellViewModels[indexPath.row]
    }
    
}

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
