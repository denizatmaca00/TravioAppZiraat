//
//  MainViewController.swift
//  TravioApp
//
//  Created by Aydın Erol on 22.11.2023.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func mainViewControllerDidLogout()
}

class MainViewController: UIViewController {
    weak var delegate: MainViewControllerDelegate?
    var viewModel: MainViewModel?
    
    deinit {
        print("dealloc \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = viewModel
        
        self.view.backgroundColor = .lightGray
        self.title = "Main"
        
        setupView()
    }
    
    func setupView(){
        
    }
}
