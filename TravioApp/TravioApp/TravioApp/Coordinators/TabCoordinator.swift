//
//  MainCoordinator.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func coordinatorDidLogout(coordinator: TabCoordinator)
}

class TabCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    var type: CoordinatorType { .tab }
    
    weak var delegate: MainCoordinatorDelegate?
    let tabBarViewController = TabBarVC()
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    deinit {
        print("dealloc \(self)")
    }
    
    func start() {
        tabBarViewController.viewModel = TabBarVM()
        tabBarViewController.viewModel.coordinator = self
        navigationController.setViewControllers([tabBarViewController], animated: false)
    }
}

extension TabCoordinator {
    func didLogout() {
        parentCoordinator?.childDidFinish(childCoordinator: self)
        parentCoordinator?.coordinatorDidLogout(coordinator: self)
    }
}
