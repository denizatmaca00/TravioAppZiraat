//
//  AppCoordinator.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

class AppCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    var isLoggedIn: Bool = false
    
    init(navigationController:UIViewController) {
        self.navigationController = navigationController as! UINavigationController
    }
    
    deinit{
        print("dealloc \(self)")
    }
    
    func start() {
        if isLoggedIn{
            showMainView()
        }
        else{
            showAuthentication()
        }
    }
}

// MARK: Handler Child and navController
extension AppCoordinator {
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in self.childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated:Bool) {
        
        /// Read the view controller where we are coming from
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController){
            return
        }
        
        if let loginViewController = fromViewController as? LoginVC {
            childDidFinish(loginViewController.viewModel.coordinator)
        }
        
        if let mainViewController = fromViewController as? TabBarVC {
            childDidFinish(mainViewController.viewModel.coordinator)
        }
    }
}

// MARK: Handler Show Login or MainView

extension AppCoordinator {
    fileprivate func showMainView(){
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.delegate = self
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
    }
    
    fileprivate func showAuthentication(){
        let authenticationCoordinator = AuthCoordinator(navigationController: navigationController)
        authenticationCoordinator.parentCoordinator = self
        authenticationCoordinator.delegate = self
        authenticationCoordinator.start()
        childCoordinators.append(authenticationCoordinator)
    }
}

extension AppCoordinator: AuthenticationCoordinatorDelegate {
    func coordinatorDidAuthenticate(coordinator: AuthCoordinator) {
        showMainView()
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func coordinatorDidLogout(coordinator: MainCoordinator) {
        showAuthentication()
    }
}
