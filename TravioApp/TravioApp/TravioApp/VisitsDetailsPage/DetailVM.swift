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
    var placeId:String?
    var creator : Place?
    var checkSuccessID: (()->())?
    var checkErrorID: (()->())?
    var showAddActionClosure: ((String, String) -> Void)?
    
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
    var postData: Messages?
    
    
    func getAPlaceById(complete: @escaping (Place)->()) {
        guard let placeId = placeId else { return }
        DispatchQueue.global().async {
            NetworkingHelper.shared.dataFromRemote(urlRequest: Router.getPlaceByID(id: placeId)){  (result:Result<PlaceIDDataStatus, Error>) in
                switch result{
                case .success(let result):
                    DispatchQueue.main.async {
                        complete(result.data.place)
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    func getAPlaceCreator(complete: @escaping (String)->()) {
        guard let placeId = placeId else { return }
        DispatchQueue.global().async {
            NetworkingHelper.shared.dataFromRemote(urlRequest: .getPlaceByID(id: placeId)){  (result:Result<PlaceIDDataStatus, Error>) in
                switch result{
                case .success(let result):
                    DispatchQueue.main.async {
                        complete(result.data.place.creator)
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    func getAllGaleryById(complete: @escaping ()->()){
        guard let placeId = placeId else { return }
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.getAllGaleryByID(id: placeId)) { [weak self] (result:Result<GalleryImage, Error>) in
            switch result {
            case .success(let result):
                self?.galeryData = result
                complete()
            case .failure(_):
                break
            }
        }
    }
    func postVisit(){
        guard let placeid = placeId else {return }
        let params = ["place_id" : placeid, "visited_at" : dateFormatter()]
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.postVisit(params: params)){
            (result:Result<Messages,Error>) in
            switch result {
            case .success(let result):
                self.postData = result
            case .failure(_):
                break
            }
        }
    }
    func dateFormatter()->String{
        let postVisitDate = DateFormatter()
        postVisitDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let today = Date()
        let postVisitToday = postVisitDate.string(from: today)
        return postVisitToday
    }
    func deleteVisitbyPlceID(){
        guard let id = placeId  else {return}
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.deleteVisit(id: id)){
            (result:Result<Messages,Error>) in
        }
    }
    
    
    func deleteMyAdded(){
        guard let id = placeId  else {return}
        NetworkingHelper.shared.dataFromRemote(urlRequest: .deleteMyAddedPlaceById(id: id)){
            (result:Result<Messages,Error>) in
        }
    }
    func checkVisitbyPlaceID(){
        guard let id = placeId  else {return}
        print(id)
        NetworkingHelper.shared.dataFromRemote(urlRequest: Router.checkVisitByID(id: id)){
            (result:Result<Messages,Error>) in
            switch result {
            case .success(let success):
                self.successCheckIdResponse = success.message
            case .failure(let failure):
                self.errorCheckIdResponse = failure.localizedDescription
            }
        }
    }
    
}

