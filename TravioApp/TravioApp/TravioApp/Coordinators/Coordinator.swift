//
//  Coordinator.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? {get set}
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    var type: CoordinatorType {get}
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.childDidFinish(childCoordinator: self)
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func childDidFinish(childCoordinator: Coordinator)
}

enum CoordinatorType {
    case app, login, signUp, tab
}
