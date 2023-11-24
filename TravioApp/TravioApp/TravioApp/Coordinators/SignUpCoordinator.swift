//
//  SignUpCoordinator.swift
//  TravioApp
//
//  Created by Aydın Erol on 23.11.2023.
//

import UIKit

protocol SignUpCoordinatorDelegate: AnyObject {
    func coordinatorDidSignUp(coordinator: SignUpCoordinator)
}

class SignUpCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    var type: CoordinatorType { .signUp }
    weak var delegate: SignUpCoordinatorDelegate?
    let signUpViewController = SignUpVC()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit{
        print("dealloc \(self)")
    }
    
    func start() {
        navigationController.setViewControllers([signUpViewController], animated: false)
    }
}

// MARK: didSignUp called by LoginViewModel
extension SignUpCoordinator {
    
    func willSignUp() {
        start()
    }
    
    func didSignUp() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
        parentCoordinator?.coordinatorDidSignUp(coordinator: self)
    }
}


