//
//  AppActivityIndicator.swift
//  TravioApp
//
//  Created by Aydın Erol on 12.11.2023.
//

import UIKit

class AppActivityIndicator: UIView {
    
    // MARK: Properties
    
    static let shared = AppActivityIndicator()
    
    lazy var lblMessage: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20 , height: 20))
        lbl.font = .Fonts.textFieldText.font
        lbl.contentMode = .center
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20 , height: 20))
        ai.color = UIColor(named: "backgroundColor")
        ai.style = .large
        ai.hidesWhenStopped = true
        return ai
    }()
    
    // MARK: Views
    
    lazy var viewBlur:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.opacity = 0.95
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.restorationIdentifier = "indicatorView"
        return blurEffectView
    }()
    
    lazy var stackView:UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 6
        return sv
    }()
    
    // MARK: Functions
    
    func displayMessage(_ message:String){
        lblMessage.text = message
        stackView.addArrangedSubview(lblMessage)
    }
}

extension UIViewController {
    
    func showIndicator(with message:String? = nil){
        
        let viewBlur = AppActivityIndicator.shared.viewBlur
        viewBlur.frame = self.view.frame
        
        let indicatorLoading = AppActivityIndicator.shared.activityIndicator
        
        let stackView = AppActivityIndicator.shared.stackView
        
        /// add UI elements to viewBlur, which is the main view here
        self.view.addSubview(viewBlur)
        viewBlur.contentView.addSubview(stackView)
        stackView.addArrangedSubview(indicatorLoading)
        
        /// if there is a given message, display mesage
        if let message = message {
            AppActivityIndicator.shared.displayMessage(message)
        }
        
        /// Add constraints to make stackView auto-resize acording to its content
        stackView.snp.makeConstraints({ sv in
            sv.center.equalToSuperview()
            sv.leading.equalToSuperview().offset(24)
            sv.trailing.equalToSuperview().inset(24)
        })
        
        indicatorLoading.startAnimating()
    }
    
    func hideIndicator(){
        for view in self.view.subviews{
            if(view.restorationIdentifier == "indicatorView"){
                view.removeFromSuperview()
            }
        }
    }
    
    ///  Meets the same requirements with toggle funcionality
    func toggleActivityIndicator(_ isEnable:Bool, message:String? = nil){
        if isEnable {
            showIndicator()
        }else{
            hideIndicator()
        }
    }
}
