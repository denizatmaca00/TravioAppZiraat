//
//  Router.swift
//  TravioApp
//
//  Created by web3406 on 10/25/23.
//

import Foundation
import Alamofire

enum Router {
    
    case register(params:Parameters)
    case user
 //   case deleteUser(id: String)
   // case putChange(id: String, params: Parameters)
    
    
    var baseURL:String {
        return "https://api.iosclass.live"
    }
    
    var path:String {
        switch self {
        case .register:
            return "/v1/auth/register"
        case .user:
            return "/v1/auth/login"
      //  case .deleteUser(let userId), .putChange(let userId, _):
     //       return "/user/\(userId)"
        }
    }
    
    
    var method:HTTPMethod {
        switch self {
        case .register:
            return .post
        case .user:
            return .get
//        case .deleteUser:
//            return .delete
//        case .putChange:
//            return .put
        }
    }
    
    
    var headers:HTTPHeaders {
        switch self {
        case .register, .user:
            //, .deleteUser, .putChange:
            return [:]
        }
    }
    
    var parameters:Parameters? {
        switch self {
        case .register(let params):
            return params
        case .user:
            return nil
//        case .putChange(_, let params):
//            return params
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
