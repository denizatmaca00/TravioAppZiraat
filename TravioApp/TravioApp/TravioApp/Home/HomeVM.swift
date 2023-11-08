//
//  HomeVM.swift
//  TravioApp
//
//  Created by Aydın Erol on 8.11.2023.
//

import UIKit

class HomeVM{
    
    // popularPlaces:
    var popularPlaces:[Place] = []
    // lastPlaces :
    var newPlaces:[Place] = []
    
    var cellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            print("doluyor")
            reloadTableViewClosure?()
        }
    }
    
    var numberOfCells:Int
    {
        return cellViewModels.count
    }
    
    // this will be filled on VisitsVC to populate tableView with updated data
    var reloadTableViewClosure: (()->())?
    
    
    func initFetch(){
        // Burası places/popular
        NetworkingHelper.shared.dataFromRemote(urlRequest: .places) {(result:Result<PlacesDataStatus, Error>) in
            
            switch result {
            case .success(let success):
                self.fetchVisits(populars: success.data.places)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getAllPlaces(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: .places) {(result:Result<PlacesDataStatus, Error>) in
            
            switch result {
            case .success(let success):
                self.fetchVisits(populars: success.data.places)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getPopularPlaces(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: .places) {(result:Result<PlacesDataStatus, Error>) in
            print("getPopularPlaces:")
            print(result)
            switch result {
            case .success(let success):
                self.fetchVisits(populars: success.data.places)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func fetchVisits(populars:[Place]){
        self.popularPlaces = populars
        
        var viewModels:[VisitCellViewModel] = [VisitCellViewModel]()
        
        for popular in populars {
            viewModels.append(createCellViewModel(popular: popular))
        }
        
        self.cellViewModels = viewModels
    }
    
    private func createCellViewModel(popular:Place) -> VisitCellViewModel{
        // converts info contained in "MyVisits" and adapts to CellViewModel for each VisitCell to show inside each vistsCell
        let cvm = VisitCellViewModel(image: UIImage(named: "sultanahmet")!,
                                     placeName: popular.title,
                                     city: popular.created_at)
        return cvm
    }
    
    
}
