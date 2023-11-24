//
//  AppCoordinator.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func showAuthentication()
    func showMainView()
    func showSignUp()
}

class AppCoordinator: NSObject, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorType { .app }
    
    init(navigationController:UIViewController) {
        self.navigationController = navigationController as! UINavigationController
    }
    
    deinit{
        print("dealloc \(self)")
    }
    
    func start() {
        showAuthentication()
    }
    
    /// Handler: Show Login
    fileprivate func showAuthentication(){
        let loginCoordinator = AuthCoordinator(navigationController: navigationController)
        loginCoordinator.parentCoordinator = self
        loginCoordinator.delegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    /// Handler: Show TabBar
    fileprivate func showMainView(){
        let tabBarCoordinator = TabCoordinator(navigationController: navigationController)
        tabBarCoordinator.parentCoordinator = self
        tabBarCoordinator.delegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
    /// Show SignUp
    fileprivate func showSignUp(){
        let signUpCoordinator = AuthCoordinator(navigationController: navigationController)
        signUpCoordinator.parentCoordinator = self
        signUpCoordinator.delegate = self
        signUpCoordinator.start()
        childCoordinators.append(signUpCoordinator)
    }
    
    fileprivate func showAddPlace(){
        let presentCoordinator = MapPresentCoordinator(navigationController: navigationController)
        presentCoordinator.parentCoordinator = self
        presentCoordinator.delegate = self
        presentCoordinator.start()
        childCoordinators.append(presentCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func childDidFinish(childCoordinator: Coordinator){
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .tab:
            navigationController.viewControllers.removeAll()
            showAuthentication()
            
        case .login:
            navigationController.viewControllers.removeAll()
            showMainView()
            
        case .signUp:
            navigationController.viewControllers.removeAll()
            showSignUp()
            
        default:
            break
        }
        
        
    }
}

/*
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
        
        if let signUpViewController = fromViewController as? SignUpVC {
            childDidFinish(signUpViewController.viewModel.coordinator)
        }
        
        if let mapPresentViewController = fromViewController as? MapPresentVC {
            childDidFinish(mapPresentViewController.viewModel.coordinator)
        }
    }
}
*/
extension AppCoordinator: AuthenticationCoordinatorDelegate {
    
    func coordinatorDidAuthenticate(coordinator: AuthCoordinator) {
        showMainView()
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func coordinatorDidLogout(coordinator: TabCoordinator) {
        showAuthentication()
    }
}

extension AppCoordinator: SignUpCoordinatorDelegate {
    
    func coordinatorDidRequestSignUp(coordinator: SignUpCoordinator) {
        showSignUp()
    }
    
    func coordinatorDidSignUp(coordinator: SignUpCoordinator) {
        showAuthentication()
    }
}

extension AppCoordinator: MapPresentCoordinatorDelegate{
    func coordinatorDidAddPlace(coordinator: MapPresentCoordinator) {
        showAddPlace()
    }
}
