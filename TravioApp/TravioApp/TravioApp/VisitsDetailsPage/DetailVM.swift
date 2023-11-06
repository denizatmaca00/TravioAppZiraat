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
    func postAVisitById(){
        guard let placeid = placeIdtest else {return }
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.postVisit(id: placeid)){
            [weak self] (result:Result<PostAVisit,Error>) in
            switch result {
            case .success(let result):
                self?.postData = result
            case .failure(let failure):
                print("hatahatahatahata\(failure.localizedDescription)")
            }
        }
    }
}
