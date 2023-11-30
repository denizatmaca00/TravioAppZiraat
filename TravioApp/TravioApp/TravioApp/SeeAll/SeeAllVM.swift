//
//  PopularPlaceVM.swift
//  TravioApp
//
//  Created by Ece Poyraz on 13.11.2023.
//

import Foundation
import UIKit
import Alamofire

class SeeAllVM{
    
    var popularCellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadPopularClosure?()
        }
    }
    var popularNew: [VisitCellViewModel] = [VisitCellViewModel](){
        didSet{
            reloadNewPopular?()
        }
    }
    var allPopular: [VisitCellViewModel] = [VisitCellViewModel](){
        didSet{
            reloadAllPopular?()
        }
    }
    var numberOfCells:Int?{
        return popularCellViewModels.count
    }
    var reloadAllPopular: (()->())?
    var reloadNewPopular: (()->())?
    var reloadPopularClosure: (()->())?
    var popularArray:[Place] = []
    
    //Popular Place
    func getPopularPlace(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.getPopularPlaces){
            (result:Result<PlacesDataStatus,Error>) in
            switch result{
            case .success(let data):
                self.fetch(array: data.data.places)
            case .failure(_):
                break
            }
            
        }
    }
    //New Places
    func newPlace(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.getNewPlaces){
            (result: Result<PlacesDataStatus,Error>) in
            switch result{
            case .success(let data):
                self.fetch(array: data.data.places)
            case .failure(_):
                break
            }
        }
    }
    //My Added Places
    func allPlaceforUser(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.getHomeAllPlacesForUser){
            (result:Result<PlacesDataStatus,Error>) in
            switch result {
            case .success(let data):
                self.fetch(array: data.data.places)
            case .failure(_):
                break
            }
        }
    }
    func fetch(array:[Place]){
        self.popularArray = array
        var viewModels:[VisitCellViewModel] = [VisitCellViewModel]()
        for item in array {
            viewModels.append(cellVM(array: item))
        }
        self.popularCellViewModels = viewModels
    }
    func cellVM(array:Place) -> VisitCellViewModel{
        let imgUrl = URL(string: array.cover_image_url)!
        let cvm = VisitCellViewModel(image:imgUrl,
                                     placeName: array.place,
                                     city: array.title)
        return cvm
    }
    func sortPlace(getSortType: sortType) {
        if !popularArray.isEmpty  {
            var newSort = popularArray
            switch getSortType {
            case .AToZ:
                newSort.sort(by: { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending })
                self.popularArray = newSort
            case .ZToA:
                newSort.sort(by: { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending })
                self.popularArray = newSort
                
            }
        }
    }
}
