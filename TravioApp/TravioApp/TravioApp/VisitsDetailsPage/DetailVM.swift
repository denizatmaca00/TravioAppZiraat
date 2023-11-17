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
    var id:String?
    var placeIdtest:String?{
        didSet{
            print(placeIdtest)
        }
    }
    var checkSuccessID: (()->())?
    var checkErrorID: (()->())?
    
    var successCheckIdResponse: String? {
        didSet{
            checkSuccessID?()
        }
    }
    var errorCheckIdResponse: String? {
        didSet{
            checkErrorID?()
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
        let params = ["place_id" : placeid, "visited_at" : dateFormatter()]
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.postVisit(params: params)){
             (result:Result<PostAVisit,Error>) in
            switch result {
            case .success(let result):
                self.postData = result
                print(self.postData)
            case .failure(let failure):
                print(failure.localizedDescription)
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
    func deleteVisitbyPlceID(){
        guard let id = placeIdtest  else {return}
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.deleteVisit(id: id)){
            (result:Result<DeleteVisitbyID,Error>) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let failure):
                print("deletehatahatahata\(failure.localizedDescription)")
            }
        }
    }
    func checkVisitbyPlaceID(){
        guard let id = placeIdtest  else {return}
        print(id)
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.checkVisitByID(id: id)){
            (result:Result<CheckVisitbyID,Error>) in
            switch result {
            case .success(let success):
                self.successCheckIdResponse = success.message
            case .failure(let failure):
                self.errorCheckIdResponse = failure.localizedDescription
            }
        }
    }
}

