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
    case places(params:Parameters)
    
    // delete and update cases
    case deleteVisit(id: String)
    case putVisit(id: String, params: Parameters)
    
//    case deletePlace(id: String)
//    case putPlace(id: String, params: Parameters)
    
    var baseURL:String {
        return "https://api.iosclass.live"
    }
    
    var token:String{
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmdWxsX25hbWUiOiJKb2huIERvZSIsImlkIjoiYmI0MjM0ZWMtZmJmNy00Y2I1LWFkYzEtZjA2NmM0MjlkYmZjIiwicm9sZSI6InVzZXIiLCJleHAiOjE2OTg0NDU3ODZ9.ZjhVVtdyjg0q7zc_HQVqLjQgdVjq4M5HEx-4TtcUDhE"
    }
    
    var path:String {
        switch self {
        case .register:
            return "/v1/auth/register"
        case .user:
            return "/v1/auth/login"
        case .visits:
            return "/v1/visits"
        case .places:
            return "/v1/places"
            
        // delete and update cases
        case .deleteVisit(let visitId):
            return "/v1/visit/\(visitId)"
        case .putVisit(let visitId, _):
            return "/v1/visit/\(visitId)"
        }
    }
    
    var method:HTTPMethod {
        switch self {
        case .register, .user, .visits, .places:
            return .post
        case .deleteVisit:
            return .delete
        case .putVisit:
            return .put
        }
    }
    
    
    var headers:HTTPHeaders {
        switch self {
        case .register, .user:
            return [:]
        case .visits, .places, .deleteVisit, .putVisit:
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["Authorization": token ]
            return config.headers
        }
    }
    
    var parameters:Parameters? {
        switch self {
        case .register(let params):
            return params
        case .user (let params):
            return params
        case .places (let params):
            return params
        case .visits:
            return nil
        // delete and update cases
        case .deleteVisit:
            return nil
        case .putVisit(_, let params):
            return params
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

