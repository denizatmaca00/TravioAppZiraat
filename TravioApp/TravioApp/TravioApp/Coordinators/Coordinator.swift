//
//  Coordinator.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators : [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}
