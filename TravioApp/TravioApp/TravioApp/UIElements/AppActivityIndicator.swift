//
//  AppActivityIndicator.swift
//  TravioApp
//
//  Created by Aydın Erol on 12.11.2023.
//

import UIKit

class AppActivityIndicator: UIView {
    
    var targetVC:LoginVC?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
//    init(frame:CGRect, targetVC: UIViewController? = nil) {
//        super.init(frame: frame)
//        self.targetVC = targetVC
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20 , height: 20))
        ai.color = UIColor(named: "backgroundColor")
        ai.style = .large
        ai.center = (targetVC?.view.center)! //(CGPoint(x: targetVC.frame.width, y:self.frame.height))
        ai.hidesWhenStopped = true
        return ai
    }()
    
    lazy var viewBlur:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = (targetVC?.view.frame)! //?? CGRect(x: 0, y: 0, width: 200, height: 400)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    func getEffect()->UIView{
        addSubviews(viewBlur)
        viewBlur.contentView.addSubviews(activityIndicator)
        
        return viewBlur
    }
    
    //@discardableResult
    func getLoadView(){
        let isLoading = (targetVC?.viewModel.isLoading)!
        if isLoading{
            targetVC?.view.addSubviews(viewBlur)
            viewBlur.contentView.addSubviews(activityIndicator)
            self.activityIndicator.startAnimating()
        }else{
            viewBlur.removeFromSuperview()
            self.activityIndicator.removeFromSuperview()
        }
    }
}

extension UIViewController {
    func showIndicator(){
        
    }
    
    func removeIndicator(){
        
    }
}
