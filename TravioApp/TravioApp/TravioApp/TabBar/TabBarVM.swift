//
//  TabBarVM.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

class TabBarVM: NSObject {
    
    weak var coordinator: TabCoordinator?
    
    deinit{
        print("dealloc \(self)")
    }
    
    // MARK: Initialization
    init(coordinator: TabCoordinator? = nil) {
        self.coordinator = coordinator
    }
}

// MARK: - Delegate MainViewController
extension TabBarVM: MainViewControllerDelegate {
    func mainViewControllerDidLogout(){
        coordinator?.didLogout()
    }
}
