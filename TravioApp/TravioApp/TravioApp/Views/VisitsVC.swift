//
//
//  VisitsVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 26.10.2023.
//
//
import UIKit
//import TinyConstraints
import SnapKit

class VisitsVC: UIViewController {
    
    //MARK: -- Properties
    

    
    //MARK: -- Views
    
    private lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        view.clipsToBounds = true
        view.layer.cornerRadius = 80
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        
        return view
    }()
    
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    //MARK: -- Component Actions
    
    
    //MARK: -- Private Methods
    
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.view.addSubviews()
        
        setupLayout()
    }
    
    func setupLayout() {
        // Add here the setup for layout
        
    }
    
}

#Preview {
    return VisitsVC()
}
