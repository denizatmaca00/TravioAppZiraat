//
//  AppLabel.swift
//  TravioApp
//
//  Created by web3406 on 11/2/23.
//

import UIKit

    
    enum SideViewStatus {
        
        case left(image:UIImage?)
        case right(image:UIImage?)
        case none
        
        var definedSideView:UIView? {
            switch self {
            case .left(let image),.right(let image):
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.tintColor = #colorLiteral(red: 0.09411764706, green: 0.2901960784, blue: 0.1725490196, alpha: 1)
                //imageView.image = #imageLiteral(resourceName: "header.psd")
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
            
                let sideView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                imageView.center = sideView.center
                sideView.addSubview(imageView)
                return sideView
            case .none:
                return nil
            }
        }
        
        func setSideView(icon:UIImage? = nil)->UIView{
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.tintColor = #colorLiteral(red: 0.09411764706, green: 0.2901960784, blue: 0.1725490196, alpha: 1)
            //imageView.image = #imageLiteral(resourceName: "header.psd")
            imageView.image = icon
            imageView.contentMode = .scaleAspectFit
        
            let sideView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.center = sideView.center
            sideView.addSubview(imageView)
            
            return sideView
            
        }
    }

class AppLabel: UILabel {
    
    var sideView: SideViewStatus? = nil {
        didSet {
            defineSideViewLocation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func defineSideViewLocation() {
        switch sideView {
        case .left(let image):
            addLeftIcon(image: image)
        case .right(let image):
            addRightIcon(image: image)
        case .none:
            break
        case .some(.none):
            break
        }
    }
    
     func addLeftIcon(image: UIImage?) {
        let iconSize: CGFloat = 20.0
        let spacing: CGFloat = 4.0
        
        let iconImageView = UIImageView(image: image)
        iconImageView.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        iconImageView.tintColor = #colorLiteral(red: 0.09411764706, green: 0.2901960784, blue: 0.1725490196, alpha: 1)
        iconImageView.contentMode = .scaleAspectFit
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.frame = CGRect(x: iconSize + spacing, y: 0, width: frame.size.width - iconSize - spacing, height: frame.size.height)
        
        addSubview(iconImageView)
        addSubview(textLabel)
    }
    
     func addRightIcon(image: UIImage?) {
        let iconSize: CGFloat = 20.0
        let spacing: CGFloat = 4.0
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width - iconSize - spacing, height: frame.size.height)
        
        let iconImageView = UIImageView(image: image)
        iconImageView.frame = CGRect(x: frame.size.width - iconSize, y: 0, width: iconSize, height: iconSize)
        iconImageView.tintColor = #colorLiteral(red: 0.09411764706, green: 0.2901960784, blue: 0.1725490196, alpha: 1)
        iconImageView.contentMode = .scaleAspectFit
        
        addSubview(textLabel)
        addSubview(iconImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
