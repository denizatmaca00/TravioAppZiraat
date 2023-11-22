//
//  MainCoordinator.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func coordinatorDidLogout(coordinator: MainCoordinator)
}

class MainCoordinator: Coordinator {
    
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    weak var delegate: MainCoordinatorDelegate?
    let mainViewController = LoginVC()
    
    init(navigationController: UINavigationController)
    {
        self.navigationController = navigationController
    }
    
    deinit {
        print("dealloc \(self)")
    }
    
    func start() {
        //mainViewController.viewModel = MainViewModel(coordinator: self)
        navigationController.setViewControllers([mainViewController], animated: false)
    }
}

extension MainCoordinator {
    func didLogout() {
        //parentCoordinator.childDidFinish(self)
        //parentCoordinator.coordinatorDidLogout(coordinator: self)
    }
}
