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
    
//    var favorites: [Place] = []

    var reloadClosure: ((Place?)->(Void))?
    var galeryData: GalleryImage?
    
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
                        print("ececececececec\(self?.galeryData)")
                        complete()
                    case .failure(let failure):
                        print(failure.localizedDescription)
                        
                    }
                }
    }
    func galleryCount() -> Int {
            guard let galeryData = galeryData else { return 0 }
            print(galeryData.data.count)
            return galeryData.data.count
        }
//    func returnGalleryImage(row: Int) -> Image {
//        guard let galeryData = galeryData else { return Image(id: "", place_id: "", image_url: "", create_at: "", updated_at: "") }
//        return galeryData.data.images[row]
//       }
}
