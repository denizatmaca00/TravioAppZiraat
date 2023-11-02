//
//  DetailVM.swift
//  TravioApp
//
//  Created by Ece Poyraz on 30.10.2023.
//
//
import Foundation
import UIKit

class DetailVM{
    var placeId:String?{
        didSet{
            print("hshdjjsdkdj\(placeId)")
        }
    }
    var favorites: [Place] = []
    private var cellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    var reloadTableViewClosure: (()->())?
   
    var currentPlace:Place? {
        didSet{
            if let reloadClosure = reloadClosure{
                reloadClosure(currentPlace)
            }
        }
    }
    var numberOfCells:Int {
        return cellViewModels.count
    }
    var reloadClosure: ((Place?)->(Void))?
    
    func getAPlaceById(complete: @escaping (Place)->()) {
        guard let placeId = placeId else { return }
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.getPlaceByID(id: placeId)){ [weak self] (result:Result<DataPlaces, Error>) in
            switch result{
            case .success(let data):
                self?.fetchVisits(favorites: data.data.places )
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
     func fetchVisits(favorites:[Place]){
        self.favorites = favorites
        
        var viewDetailsModels = [VisitCellViewModel]()
        
        for favorite in favorites {
            viewDetailsModels.append(createCellViewModel(favorite: favorite))
        }
        
        self.cellViewModels = viewDetailsModels
    }
    private func createCellViewModel(favorite:Place) -> VisitCellViewModel{
        // converts info contained in "MyVisits" and adapts to CellViewModel for each VisitCell to show inside each vistsCell
//        let test = Placetext(id: favorite.id, creator: favorite.creator, place: favorite.place, description: favorite.description, created_at: favorite.created_at)
        let test = VisitCellViewModel(image: UIImage(named: "sultanahmet")!,
                                     placeName: favorite.title,
                                      city: favorite.place)
        var deneme123 = [test]
        print("heeeeeeeeeeeejskfjsdlfkdşsqlkfişeeeeeey\(deneme123)")
        return test
    }
    func initFetch(){
        // here places will be fetchED from the server using .visits for VisitsVC and will be used to fill favorites:[Place/Visit] array
        
        NetworkingHelper.shared.dataFromRemote(urlRequest: .visits) { [weak self] (result:Result<DataPlaces, Error>) in
            
            switch result {
            case .success(let data):
                self?.fetchVisits(favorites: data.data.places )
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
