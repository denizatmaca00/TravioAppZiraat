//
//  AppButton.swift
//  TravioApp
//
//  Created by Aydın Erol on 14.10.2023.
//

import UIKit

enum ButtonBackgroundColor
{
    case enabled
    case disabled
    
    var definedBackgroundColor:UIColor?{
        switch self {
        case .disabled:
            return UIColor(named: "inactiveButtonColor")
        case .enabled:
            return UIColor(named: "backgroundColor")
        }
    }
}

class AppButton: UIButton {
    
    let poppins = UIFont(name: "Poppins-Bold", size: 16)
    
    var buttonColor:ButtonBackgroundColor? = .disabled {
        didSet{
            defineBackgroundColor()
        }
    }
    
    override var isEnabled: Bool {
        didSet{
            defineBackgroundColor()
        }
    }
    
    func defineBackgroundColor(){
        
        switch self.isEnabled
        {
        case false:
            print("yanlis")
            self.backgroundColor = UIColor(named: "inactiveButtonColor")
        case true:
            print("dogru")
            self.backgroundColor = UIColor(named: "backgroundColor")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 16

        //self.setTitle("Button", for: .normal)
        self.titleLabel?.font = poppins
        self.setTitleColor(UIColor(named: "textColorReversed"), for: .normal)
        self.backgroundColor = UIColor(named: "backgroundColor")
        
        self.isEnabled = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension AppButton
{
    func showAlert()
    {
        
    }
}
