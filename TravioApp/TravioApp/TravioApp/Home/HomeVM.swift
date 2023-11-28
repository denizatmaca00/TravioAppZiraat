//
//  HomeVM.swift
//  TravioApp
//
//  Created by Aydın Erol on 8.11.2023.
//

import UIKit

class HomeVM{
    
    var popularPlaces:[Place] = []
    var newPlaces:[Place] = []
    var allPlaces:[Place] = []
    
    var sectionsArray:[[Place]] = []
   
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
    
    func initFetchPopularHomeLimits(limit: Int) {
        let params = ["limit":"\(limit)"]
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getPopularPlacesLimits(limit: params)) {(result: Result<PlacesDataStatus, Error>) in
            switch result {
            case .success(let success):
                self.fetchVisits(populars: success.data.places)
                
            case .failure(_):
                return
            }
            self.sectionsArray[0] = self.popularPlaces
        }
    }
     
    func initFetchNewHomeLimits(limit: Int) {
        let params = ["limit":"\(limit)"]
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getNewPlacesLimits(limit: params)) {(result: Result<PlacesDataStatus, Error>) in
            switch result {
            case .success(let success):
                self.fetchNewPlaces(news: success.data.places)
                
            case .failure(_):
                break
            }
            self.sectionsArray[1] = self.newPlaces
        }
    }
    //failrire
    func initFetchAllForUserHomeAll(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getHomeAllPlacesForUser) {(result:Result<PlacesDataStatus, Error>) in
            switch result {
            case .success(let success):
                self.fetchAllPlacesForUser(allForUsers: success.data.places)
                
            case .failure(_):
                break
            }
            self.sectionsArray[2] = self.allPlaces
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
      //  guard let imageURL = URL(string: cell.cover_image_url) else { return  deneme }
        let cvm = VisitCellViewModel(image: URL(string: cell.cover_image_url)!,
                                     placeName: cell.title,
                                     city: cell.place)
        return cvm
    }
    
}
