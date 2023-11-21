//
//  Router.swift
//  TravioApp
//
//  Created by web3406 on 10/25/23.
//

import Foundation
import Alamofire

enum Router {
    
    // get/post cases
    case register(params:Parameters)
    case user(params: Parameters)
    case visits
    case places
    case deleteVisit(id: String)
    //case postVisit(id: String, params: Parameters)
    case postVisit(params:Parameters)

    
    //    case deletePlace(id: String)
    //    case putPlace(id: String, params: Parameters)
    case getPlaceByID(id:String)
    //galeryAllGaleryByID;
    case getAllGaleryByID(id:String)
    case putEditProfile(params: Parameters)
    case getProfile
    
    case getAVisitByID(id:String)
    case checkVisitByID(id:String)
    case getPopularPlaces
    case getPopularPlacesLimits(limit: Parameters)
    case getNewPlaces
    case getNewPlacesLimits(limit: Parameters)
    case getHomeAllPlacesForUser
    case postGalleryImage(params: Parameters) // used to create place-image couples
    case uploadAddPhoto(params: Parameters)
    case postAddPlace(params: Parameters)
    //password change
    case putPassword(params:Parameters)
    
    var baseURL:String {
        return "https://ios-class-2f9672c5c549.herokuapp.com"
    }
    
    var path:String {
        switch self {
        case .register:
            return "/v1/auth/register"
        case .user:
            return "/v1/auth/login"
        case .places:
            return "/v1/places"
        case .postVisit:
            return "/v1/visits"
        case .putEditProfile:
            return "/v1/edit-profile"
        case .getProfile:
            return "/v1/me"
        case .getPopularPlaces, .getPopularPlacesLimits:
            return "/v1/places/popular"
        case .getNewPlaces, .getNewPlacesLimits:
            return "/v1/places/last"
            
            // delete and update cases
        case .deleteVisit(let visitId):
            return "/v1/visits/\(visitId)"
        case .postVisit:
            return "/v1/visits"
        case .getPlaceByID(let id):
            return "/v1/places/\(id)"
        
        // GALLERY
        case .postGalleryImage:
            return "/v1/galleries"
            //get all galery by id
        case .getAllGaleryByID(let id):
            return "/v1/galleries/\(id)"

        // VISITS
        case .visits:
            return "/v1/visits"
        case .getAVisitByID(let id):
            return "/v1/visits/\(id)"
        case .checkVisitByID(let id):
            return "/v1/visits/user/\(id)"
        case.getHomeAllPlacesForUser:
            return"/v1/places/user"
        
        case .uploadAddPhoto:
            return "/upload"
        case .postAddPlace:
            return "/v1/places"
        case .putPassword:
            return "v1/change-password"
        }
    }
    
    var method:HTTPMethod {
        switch self {
        case .register, .user, .postVisit, .uploadAddPhoto, .postAddPlace, .postGalleryImage:
            return .post
        case .places, .getPlaceByID, .getAllGaleryByID, .visits, .getAVisitByID, .checkVisitByID, .getProfile, .getPopularPlaces, .getPopularPlacesLimits, .getNewPlaces, .getNewPlacesLimits, .getHomeAllPlacesForUser:
            return .get
        case .deleteVisit:
            return .delete
        case .putEditProfile, .putPassword:
            return .put
        }
    }
    
    var headers: HTTPHeaders {
        var baseHeaders: HTTPHeaders = [:]
        
        if let token = KeychainHelper.shared.getToken(){
            baseHeaders["Authorization"] = "Bearer " + token
        }
        switch self {
        case .register, .user, .getPlaceByID, .getAllGaleryByID, .getPopularPlaces, .getPopularPlacesLimits, .getNewPlaces, .getNewPlacesLimits, .uploadAddPhoto:
            return [:]
        case  .places, .deleteVisit, .postVisit, .visits, .getAVisitByID, .checkVisitByID, .putEditProfile, .getProfile, .getHomeAllPlacesForUser, .postAddPlace, .postGalleryImage, .putPassword :
            return baseHeaders
        }
    }
    
    var parameters:Parameters? {
        switch self {
        case .register(let params):
            return params
        case .user (let params):
            return params
        case .places, .visits:
            return nil
            
            // delete and post cases
        case .deleteVisit:
            return nil
        case .putEditProfile(let params):
            return params
        case .postVisit(let params):
            return params
        case .getPopularPlacesLimits(let params):
            return params
        case .getNewPlacesLimits(let params):
            return params
        case .uploadAddPhoto(let params):
            return params
        case .postAddPlace(let params):
            return params
        case .postGalleryImage(let params):
            return params
        case .putPassword(let params):
            return params
        default: return [:]
        }
    }
}

extension Router:URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        
        let encoding:ParameterEncoding = {
            switch method {
            case .put, .post:
                return JSONEncoding.default
                
            default:
                return URLEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    
    
}

