//
//  PopularPlaceVM.swift
//  TravioApp
//
//  Created by Ece Poyraz on 13.11.2023.
//

import Foundation
import UIKit
import Alamofire

class PopularPlaceVM{
    
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
    
    //POPULAR PLACE
    func getPopularPlace(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.getPopularPlaces){
            (result:Result<PlacesDataStatus,Error>) in
            switch result{
            case .success(let data):
                self.fetch(array: data.data.places)
                print(data.data.places)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            
        }
    }
    //NEW PLACE
    func newPlace(){
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.getNewPlaces){
            (result: Result<PlacesDataStatus,Error>) in
            switch result{
            case .success(let data):
                print(data.data.places)
                self.fetch(array: data.data.places)
            case .failure(let failure):
                print(failure.localizedDescription)
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
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    func fetch(array:[Place]){
        self.popularArray = array
        var viewModels:[VisitCellViewModel] = [VisitCellViewModel]()
        for item in array {
            viewModels.append(cellVM(array: item))
        }
        print(array)
        print(array.count)
        self.popularCellViewModels = viewModels
    }
     func cellVM(array:Place) -> VisitCellViewModel{
        let imgUrl = URL(string: array.cover_image_url)!
        let cvm = VisitCellViewModel(image:imgUrl,
                                     placeName: array.place,
                                     city: array.title)
        return cvm
    }
}
