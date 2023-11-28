//
//  AppActivityIndicator.swift
//  TravioApp
//
//  Created by Aydın Erol on 12.11.2023.
//

import UIKit

class AppActivityIndicator: UIView {
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20 , height: 20))
        ai.color = UIColor(named: "backgroundColor")
        ai.style = .large
        ai.hidesWhenStopped = true
        return ai
    }()
    
    lazy var viewBlur:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
}

extension UIViewController {
    
    func showIndicator(){
        let viewBlur = AppActivityIndicator().viewBlur
        viewBlur.frame = self.view.frame
        viewBlur.restorationIdentifier = "indicatorView"
        
        let indicatorLoading = AppActivityIndicator().activityIndicator
        indicatorLoading.center = self.view.center
        
        viewBlur.contentView.addSubview(indicatorLoading)
        
        self.view.addSubviews(viewBlur)
        indicatorLoading.startAnimating()
    }
    
    func hideIndicator(){
        for view in self.view.subviews{
            if(view.restorationIdentifier == "indicatorView"){
                view.removeFromSuperview()
            }
        }
    }
    
//    backup toggle function
//    func toggleIndicator(_ isEnable:Bool){
//        let viewBlur = AppActivityIndicator().viewBlur
//        viewBlur.frame = self.view.frame
//        viewBlur.restorationIdentifier = "indicatorView"
//        
//        let indicatorLoading = AppActivityIndicator().activityIndicator
//        indicatorLoading.center = self.view.center
//        
//        viewBlur.contentView.addSubview(indicatorLoading)
//        
//        if isEnable{
//            self.view.addSubviews(viewBlur)
//            indicatorLoading.startAnimating()
//        }
//        
//        if !isEnable{
//            for view in self.view.subviews{
//                if(view.restorationIdentifier == "indicatorView"){
//                    view.removeFromSuperview()
//                }
//            }
//        }
//    }
}
