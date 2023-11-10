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
    //    // lastPlaces :
    var newPlaces:[Place] = []
    var allPlaces:[Place] = []
    
    
   
    var popularCellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadPopularClosure?()
        }
    }
    var newCellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadNewPlacesClosure?()
        }
    }
    var allForUserCellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadAllForUserPlacesClosure?()
        }
    }
    
    var numberOfCells:Int
    {
        return popularCellViewModels.count
    }
    
    var reloadPopularClosure: (()->())?
    var reloadNewPlacesClosure: (()->())?
    var reloadAllForUserPlacesClosure: (()->())?
    
    
    func initFetchPopularHomeAll(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getPopularPlaces) {(result:Result<PlacesDataStatus, Error>) in
            
            switch result {
            case .success(let success):
                self.fetchVisits(populars: success.data.places)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func initFetchPopularHomeLimits(limit: Int) {
        let params = ["limit":"\(limit)"]
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getPopularPlacesLimits(limit: params)) {(result: Result<PlacesDataStatus, Error>) in
            switch result {
            case .success(let success):
                self.fetchVisits(populars: success.data.places)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func initFetchNewHomeAll(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getNewPlaces) {(result:Result<PlacesDataStatus, Error>) in
            switch result {
            case .success(let success):
                self.fetchNewPlaces(news: success.data.places)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func initFetchNewHomeLimits(limit: Int) {
        let params = ["limit":"\(limit)"]
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getNewPlacesLimits(limit: params)) {(result: Result<PlacesDataStatus, Error>) in
            print(result)
            switch result {
            case .success(let success):
                self.fetchNewPlaces(news: success.data.places)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    func initFetchAllForUserHomeAll(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getHomeAllPlacesForUser) {(result:Result<PlacesDataStatus, Error>) in
            print("getAllPlacesLimits:")
            switch result {
            case .success(let success):
                self.fetchAllPlacesForUser(allForUsers: success.data.places)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
     
    private func fetchVisits(populars:[Place]){
        self.popularPlaces = populars
        
        var viewModels:[VisitCellViewModel] = [VisitCellViewModel]()
        
        for popular in populars {
            viewModels.append(createCellViewModel(cell: popular))
        }
        
        self.popularCellViewModels = viewModels
    }
    func fetchNewPlaces(news: [Place]) {
        self.newPlaces = news
        
        var viewModels: [VisitCellViewModel] = []
        
        for new in news {
            viewModels.append(createCellViewModel(cell: new))
        }
        
        self.newCellViewModels = viewModels
    }
    func fetchAllPlacesForUser(allForUsers: [Place]) {
        self.allPlaces = allForUsers
        
        var viewModels: [VisitCellViewModel] = []
        
        for all in allForUsers {
            viewModels.append(createCellViewModel(cell: all))
        }
        
        self.allForUserCellViewModels = viewModels
    }
    
    private func createCellViewModel(cell:Place) -> VisitCellViewModel{
        let cvm = VisitCellViewModel(image: UIImage(named: "sultanahmet")!,
                                     placeName: cell.title,
                                     city: cell.place)
        return cvm
    }
    
}
