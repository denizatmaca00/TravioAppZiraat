//
//  DetailVM.swift
//  TravioApp
//
//  Created by Ece Poyraz on 30.10.2023.
//
//
//import Foundation
//
class DetailVM{
    
    var currentPlace:Place? {
        didSet{
            if let reloadClosure = reloadClosure{
                reloadClosure(currentPlace)
            }
        }
    }

    var reloadClosure: ((Place?)->(Void))?
}

