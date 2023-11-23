//
//  MapPresentCoordinator.swift
//  TravioApp
//
//  Created by Aydın Erol on 23.11.2023.
//

import UIKit

protocol MapPresentCoordinatorDelegate: AnyObject {
    func coordinatorDidAddPlace(coordinator: MapPresentCoordinator)
}

class MapPresentCoordinator: Coordinator {
    
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    weak var delegate: MapPresentCoordinatorDelegate?
    let mapPresentVC = MapPresentVC()
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    deinit {
        print("dealloc \(self)")
    }
    
    func start() {
        mapPresentVC.viewModel.coordinator = self
        navigationController.setViewControllers([mapPresentVC], animated: false)
    }
}

extension MapPresentCoordinator {
    
    func didAddPlace() {
        parentCoordinator?.childDidFinish(self)
        parentCoordinator?.coordinatorDidAddPlace(coordinator: self)
    }
}
