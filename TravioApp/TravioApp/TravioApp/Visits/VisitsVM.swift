//
//  VisitsViewModel.swift
//  TravioApp
//
//  Created by Aydın Erol on 27.10.2023.
//

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
    
    // this will be filled on VisitsVC to populate tableView with updated data
    var reloadTableViewClosure: (()->())?
    
    /// Here places will be fetchED from the server using .visits for VisitsVC and will be used to fill favorites:[Place/Visit] array
    func initFetch(){
        
        NetworkingHelper.shared.dataFromRemote(urlRequest: .visits) {(result:Result<VisitsDataStatus, Error>) in
            
            switch result {
            case .success(let success):
                self.fetchVisits(favorites: success.data.visits)
                
            case .failure(_):
                return
            }
        }
    }
    
    func getaVisitbyID(){
        guard let idplace = id?.place_id  else {return}
        NetworkingHelper.shared.dataFromRemote(urlRequest: .getAVisitByID(id: idplace)){(result:Result<VisitsDataStatus,Error>) in
            switch result{
            case .success(_):
                break
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
    
    /// Converts info contained in "MyVisits" and adapts to CellViewModel for each VisitCell to show inside each vistsCell
    private func createCellViewModel(favorite:Visit) -> VisitCellViewModel{
        
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
