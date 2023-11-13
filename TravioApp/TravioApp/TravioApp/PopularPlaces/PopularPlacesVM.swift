//
//  PopularPlacesVM.swift
//  TravioApp
//
//  Created by Aydın Erol on 13.11.2023.
//

import Foundation

class PopularPlacesVM{
    
    var placeData:[Place] = [Place](){
        didSet{
            
        }
    }
    var cellViewModels: [VisitCellViewModel] = [VisitCellViewModel](){
        didSet{
            print("didset triggered inside PopularPlacesVM")
            reloadTableViewClosure?()
        }
    }
    
    var reloadTableViewClosure:(()->())?
    
    var numberOfCells:Int?
    {
        return placeData.count
    }
    
    func fetchPopularPlaces(data:[Place]){
        self.placeData = data
        
        var viewModels:[VisitCellViewModel] = [VisitCellViewModel]()
        
        for place in placeData {
            viewModels.append(createCellViewModel(place: place))
            print(place.place)
        }
        
        self.cellViewModels = viewModels
    }
    
    private func createCellViewModel(place:Place) -> VisitCellViewModel{
        let imgUrl = URL(string: place.cover_image_url)!
        
        let cvm = VisitCellViewModel(image:imgUrl,
                                     placeName: place.title,
                                     city: place.place)
        return cvm
    }
    
    func getCellViewModel(at indexPath:IndexPath)->VisitCellViewModel{
        return cellViewModels[indexPath.row]
    }
}
