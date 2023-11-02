//
//  NetworkVM.swift
//  TravioApp
//
//  Created by Ece Poyraz on 25.10.2023.
//

import Foundation
import Alamofire

class NetworkVM{
    
    func postUserData(name:String?,email:String?,password:String?){
       
        let paramsPost = ["full_name":name,
                          "email":email,
                          "password":password]
        
        NetworkingHelper.shared.dataFromRemote(urlRequest: .register(params: paramsPost), callback: { (result:Result<User,Error>) in
            
            print(result)
        })
   
    }
    
}
