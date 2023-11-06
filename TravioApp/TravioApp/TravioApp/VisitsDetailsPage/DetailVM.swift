//
//  DetailVM.swift
//  TravioApp
//
//  Created by Ece Poyraz on 30.10.2023.
//
//
import Foundation
import UIKit
import Alamofire

class DetailVM{
    //mapten gelen placeid olacak.
    var placeIdtest:String?{
        didSet{
            print("saflfşskşfdsklşfdks\(placeIdtest)")
        }
    }

    var reloadClosure: ((Place?)->(Void))?
    var galeryData: GalleryImage?
    var postData: PostAVisit?
    
    
    func getAPlaceById(complete: @escaping (Place)->()) {
        guard let placeId = placeIdtest else { return }
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.getPlaceByID(id: placeId)){ [weak self] (result:Result<PlaceIDDataStatus, Error>) in
            switch result{
            case .success(let result):
                complete(result.data.place)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    func getAllGaleryById(complete: @escaping ()->()){
         guard let placeId = placeIdtest else { return }
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.getAllGaleryByID(id: placeId)) { [weak self] (result:Result<GalleryImage, Error>) in
                    switch result {
                    case .success(let result):
                        self?.galeryData = result
                        complete()
                        print("ececececececec\(self?.galeryData)")
                    case .failure(let failure):
                        print("hatahatahatahata\(failure.localizedDescription)")
                        
                    }
                }
    }
    func postVisit(){
        guard let placeid = placeIdtest else {return }
//"2023-08-10T00:00:00Z"
        let params = ["place_id" : placeid, "visited_at" : dateFormatter()]
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.postVisit(params: params)){
             (result:Result<PostAVisit,Error>) in
            switch result {
            case .success(let result):
                self.postData = result
                print(self.postData)
            case .failure(let failure):
                print("hatahatahatahata\(failure.localizedDescription)")
            }
        }
    }
    func dateFormatter()->String{
        let dene = DateFormatter()
        dene.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let today = Date()
        let testttttt = dene.string(from: today)
        
        return testttttt
    }
}
