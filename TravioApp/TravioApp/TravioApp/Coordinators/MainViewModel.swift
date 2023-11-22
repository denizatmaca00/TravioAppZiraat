//
//  MainViewModel.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

class MainViewModel: NSObject {
    
    weak var coordinator: MainCoordinator?
    
    deinit{
        print("dealloc \(self)")
    }
    
    // MARK: Initialization
    init(coordinator: MainCoordinator? = nil) {
        self.coordinator = coordinator
    }
}

// MARK: - Delegate MainViewController
extension MainViewModel: MainViewControllerDelegate {
    func mainViewControllerDidLogout(){
        coordinator?.didLogout()
    }
}
