//
//  AuthCoordinator.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

protocol AuthenticationCoordinatorDelegate: AnyObject {
    func coordinatorDidAuthenticate(coordinator: AuthCoordinator)
}

class AuthCoordinator: Coordinator {
    
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
        loginViewController.viewModel = LoginVM()
        loginViewController.viewModel.coordinator = self
        navigationController.setViewControllers([loginViewController], animated: false)
    }
}

extension AuthCoordinator {
    
    func didAuthenticate() {
        parentCoordinator?.childDidFinish(self)
        parentCoordinator?.coordinatorDidAuthenticate(coordinator: self)
    }
}
