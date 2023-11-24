//
//  AuthCoordinator.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

protocol AuthenticationCoordinatorDelegate: AnyObject {
    func coordinatorDidAuthenticate(coordinator: AuthCoordinator)
    func coordinatorDidRequestSignUp(coordinator: SignUpCoordinator)
}

class AuthCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var type: CoordinatorType { .login }
    
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    weak var delegate:AuthenticationCoordinatorDelegate?
    let loginViewController = LoginVC()
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    deinit {
        print("deallocating \(self)")
    }
    
    func start() {
        loginViewController.viewModel.coordinator = self
        navigationController.setViewControllers([loginViewController], animated: true)
    }
}

extension AuthCoordinator {
    
    func didRequestSignUp(){
        parentCoordinator?.childDidFinish(childCoordinator: self)
        //parentCoordinator?.coordinatorDidRequestSignUp(coordinator: SignUpCoordinator)
    }
    
    func didAuthenticate() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
        parentCoordinator?.coordinatorDidAuthenticate(coordinator: self)
    }
}
