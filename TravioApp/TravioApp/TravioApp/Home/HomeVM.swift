//
//  HomeVM.swift
//  TravioApp
//
//  Created by Aydın Erol on 8.11.2023.
//

import UIKit

class HomeVM{
    
    // MARK: Properties
    
    var dispatchGroup = DispatchGroup()
    
    var popularPlaces:[Place] = []
    var newPlaces:[Place] = []
    var allPlaces:[Place] = []
    
    var place:[VisitCellViewModel] = []
    var sectionsArray:[[Place]] = []
    
    // Cell Models
    var popularCellViewModels: [VisitCellViewModel] = [VisitCellViewModel]()
    var newCellViewModels: [VisitCellViewModel] = [VisitCellViewModel]()
    var allForUserCellViewModels: [VisitCellViewModel] = [VisitCellViewModel]()
    
    var numberOfCells:Int
    {
        return popularCellViewModels.count
    }
    
    // Closures
    var reloadClosure: (()->())?
    var indicatorUpdateClosure: ((Bool, String?)->())?
    var reloadPopularClosure: (()->())?
    var reloadNewPlacesClosure: (()->())?
    var reloadAllForUserPlacesClosure: (()->())?
    
    // MARK: API Call Functions
    
    func initFetchPopularHomeLimits(limit: Int,complete: @escaping ()->()) {
        
        self.indicatorUpdateClosure?(true, "Getting all popular places.")
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getPopularPlacesLimits(limit: ["limit":"\(limit)"])) { [weak self] (result: Result<PlacesDataStatus, Error>) in
            self?.indicatorUpdateClosure?(true, nil)
            switch result {
            case .success(let success):
                self?.fetchVisits(populars: success.data.places)
                
            case .failure(_):
                return
            }
            complete()
            self?.indicatorUpdateClosure?(false, nil)
            self?.sectionsArray[0] = self?.popularPlaces ?? []
        }
    }
    
    func initFetchNewHomeLimits(limit: Int,complete: @escaping ()->()) {
        
        self.indicatorUpdateClosure?(true, "Getting all data for new places.")
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getNewPlacesLimits(limit: ["limit":"\(limit)"])) { [weak self] (result: Result<PlacesDataStatus, Error>) in
            switch result {
            case .success(let success):
                self?.fetchNewPlaces(news: success.data.places)
                
            case .failure(_):
                return
            }
            complete()
            self?.indicatorUpdateClosure?(false, nil)
            self?.sectionsArray[1] = self?.newPlaces ?? []
        }
    }
    
    func initFetchAllForUserHomeAll(complete: @escaping ()->()) {
        
        self.indicatorUpdateClosure?(true, "Getting all places for user.")
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getHomeAllPlacesForUser) { [weak self] (result: Result<PlacesDataStatus, Error>) in
            
            switch result {
            case .success(let success):
                self?.fetchAllPlacesForUser(allForUsers: success.data.places)
                
            case .failure(_):
                return
            }
            complete()
            self?.indicatorUpdateClosure?(false, nil)
            self?.sectionsArray[2] = self?.allPlaces ?? []
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
    
    func createCellViewModel(cell:Place) -> VisitCellViewModel{
        let cvm = VisitCellViewModel(image: URL(string: cell.cover_image_url)!,
                                     placeName: cell.title,
                                     city: cell.place)
        return cvm
    }
    
}
