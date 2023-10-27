//
//  VisitsViewModel.swift
//  TravioApp
//
//  Created by Aydın Erol on 27.10.2023.
//

import Foundation
import UIKit

class VisitsViewModel{
    
    private var favorites: [Visit] = [Visit]()
    
    private var cellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    
    var numberOfCells:Int {
        return favorites.count
    }
    
    // this will be filled on VisitsVC to populate tableView with updated data
    var reloadTableViewClosure: (()->())?
    
    func initFetch(){
        
        //let postParams = ["id": 1]
        NetworkingHelper.shared.dataFromRemote(urlRequest: .visits) { [weak self] (result:Result<Place, Error>) in
            print(result)
            self?.fetchVisits(favorites: self?.favorites ?? [])
        }
    }
    
    // MARK: Create View Model
    
    func fetchVisits(favorites:[Visit]){
        self.favorites = favorites
        var viewModels = [VisitCellViewModel]()
        
        for favorite in favorites {
            viewModels.append( createCellViewModel(favorite: favorite))
        }
        self.cellViewModels = viewModels
    }
    
    func createCellViewModel(favorite:Visit) -> VisitCellViewModel{
        
        // here favorite.place_id 's are placeholders, a function should take place_id and convert into placeName and placeCity.
        let cvm = VisitCellViewModel(placeName: favorite.place_id,
                                     city: favorite.place_id)
        
        return cvm
    }
    
    func getCellViewModel(at indexPath:IndexPath)->VisitCellViewModel{
        return cellViewModels[indexPath.row]
    }
    
}

struct VisitCellViewModel{
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
