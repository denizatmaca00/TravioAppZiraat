//
//  VisitsViewModel.swift
//  TravioApp
//
//  Created by Aydın Erol on 27.10.2023.
//

import Foundation
import UIKit

class VisitsVM{
    var id: Visit?
    var favorites: [Visit] = []
    

     var cellViewModels: [VisitCellViewModel] = [VisitCellViewModel]() {
        didSet {
            reloadTableViewClosure?()
            numberOfCells = cellViewModels.count
            reloadTableViewClosure?()
        }
    }
    
    var numberOfCells:Int?
//    {
//        return cellViewModels.count
//    }
    
    // this will be filled on VisitsVC to populate tableView with updated data
    var reloadTableViewClosure: (()->())?
    
    func initFetch(){
        // here places will be fetchED from the server using .visits for VisitsVC and will be used to fill favorites:[Place/Visit] array
        
        NetworkingHelper.shared.dataFromRemote(urlRequest: .visits) {(result:Result<VisitsDataStatus, Error>) in
            
            switch result {
            case .success(let success):
                self.fetchVisits(favorites: success.data.visits)
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getaVisitbyID(){
        guard let idplace = id?.place_id  else {return}
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getAVisitByID(id: idplace)){(result:Result<VisitsDataStatus,Error>) in
            switch result{
            case .success(let success):
                print(success.status)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    // MARK: Create View Model
    
    private func fetchVisits(favorites:[Visit]){
        self.favorites = favorites
        
        var viewModels:[VisitCellViewModel] = [VisitCellViewModel]()
        
        for favorite in favorites {
            viewModels.append(createCellViewModel(favorite: favorite))
        }
        
        self.cellViewModels = viewModels
    }

    private func createCellViewModel(favorite:Visit) -> VisitCellViewModel{
    // converts info contained in "MyVisits" and adapts to CellViewModel for each VisitCell to show inside each vistsCell
       // guard let te = favorite.place.cover_image_url else {return VisitCellViewModel}
        // "sultanahmet"
        //URL(string: imageURL.place.cover_image_url)
//        func configure(imageURL:Visit){
//            if let url = URL(string: favorite.place.cover_image_url){
//                //self.image.imageFrom(url: url)
//                //resmi indir ve görğntülerim
//                 imageLocation.kf.setImage(with: url)
//            }}
        
        let imgUrl = URL(string: favorite.place.cover_image_url)!
        let cvm = VisitCellViewModel(image:imgUrl,
                                     placeName: favorite.place.title,
                                     city: favorite.place.place)
        return cvm
    }
    
    func getCellViewModel(at indexPath:IndexPath)->VisitCellViewModel{
        return cellViewModels[indexPath.row]
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct VisitsVM_Preview: PreviewProvider {
    static var previews: some View{
        
        VisitsVC().showPreview()
    }
}
#endif
