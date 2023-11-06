//
//  AppView.swift
//  TravioApp
//
//  Created by web3406 on 11/6/23.
//

import UIKit

class AppView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(named: "viewBackgroundColor")
        clipsToBounds = true
        layer.cornerRadius = 80
        layer.maskedCorners = [.layerMinXMinYCorner]
    }
}
