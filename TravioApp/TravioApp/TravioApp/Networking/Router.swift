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
    
    // delete and update cases
    case deleteVisit(id: String)
    case postVisit(id: String, params: Parameters)

    
//    case deletePlace(id: String)
//    case putPlace(id: String, params: Parameters)
    case getPlaceByID(id:String)
    
//    var token:String{
//        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmdWxsX25hbWUiOiJEZW5lbWUiLCJpZCI6IjAzNDhkYzFkLWYyY2ItNDk5ZC1iOTA0LTk5ODI2OTBmZWMxMCIsInJvbGUiOiJ1c2VyIiwiZXhwIjoxNjk4OTMwNjQ3fQ.fx4j9xmEYYn8-E2ilKJM2sqQku4fMiZdq70sxE1UCUY"
//    }
    
    var baseURL:String {
        return "https://api.iosclass.live"
    }
    
    var path:String {
        switch self {
        case .register:
            return "/v1/auth/register"
        case .user:
            return "/v1/auth/login"
        case .visits:
            return "/v1/visits?page=1&limit=10"
        case .places:
            return "/v1/places"
        case .postVisit:
            return "/v1/visits"
        
            
        // delete and update cases
        case .deleteVisit(let visitId):
            return "/v1/visit/\(visitId)"
        case .postVisit(let visitId, _):
            return "/v1/visits/\(visitId)"
        case .getPlaceByID(let id):
            return "/v1/visits/\(id)"
        }
    }
    
    var method:HTTPMethod {
        switch self {
        case .register, .user, .postVisit, .visits:
            return .post
        case .places, .getPlaceByID:
            return .get
        case .deleteVisit:
            return .delete
//        case .postVisit:
//            return .put
        }
    }
    
    var headers: HTTPHeaders {
            var baseHeaders: HTTPHeaders = [:]

        if let token = KeychainHelper.shared.getToken(){
        baseHeaders["Authorization"] = token            
        }
            switch self {
            case .register, .user, .getPlaceByID:
                return baseHeaders
            case .visits, .places, .deleteVisit, .postVisit:
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
            
        // delete and update cases
        case .deleteVisit:
            return nil
        case .postVisit(_, let params):
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
            case .post:
                return JSONEncoding.default

            default:
                return URLEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    
    
}

