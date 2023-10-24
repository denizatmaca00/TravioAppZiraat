//
//  Router.swift
//  MvvmBir
//
//  Created by web3406 on 10/23/23.
//

import Foundation
import Alamofire

enum Router {
    
    case register(params:Parameters)
    case user
    case deleteUser(id: String)
    case putChange(id: String, params: Parameters)
    
    
    var baseURL:String {
        return "https://65312bc24d4c2e3f333c8a9c.mockapi.io"
    }
    
    var path:String {
        switch self {
        case .register,.user:
            return "/user"
        case .deleteUser(let userId), .putChange(let userId, _):
            return "/user/\(userId)"
        }
    }
    
    
    var method:HTTPMethod {
        switch self {
        case .register:
            return .post
        case .user:
            return .get
        case .deleteUser:
            return .delete
        case .putChange:
            return .put
        }
    }
    
    
    var headers:HTTPHeaders {
        switch self {
        case .register, .user, .deleteUser, .putChange:
            return [:]
        }
    }
    
    var parameters:Parameters? {
        switch self {
        case .register(let params):
            return params
        case .user, .deleteUser:
            return nil
        case .putChange(_, let params):
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
            case .post , .put:
                return JSONEncoding.default

            default:
                return URLEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    
    
}
