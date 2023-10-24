//
//  Struct.swift
//  MvvmBir
//
//  Created by web3406 on 10/23/23.
//

import Foundation

struct User: Codable {
    var name: String?
    var phoneNumber: String?
    var email: String?
    var note: String?
    var id: String?
    
    enum CodingKeys: String,CodingKey {
        case name
        case phoneNumber
        case email
        case note
        case id
    }
}
