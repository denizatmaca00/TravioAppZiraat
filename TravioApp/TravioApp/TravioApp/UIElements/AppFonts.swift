//
//  AppFonts.swift
//  TravioApp
//
//  Created by Aydın Erol on 7.11.2023.
//

import Foundation
import UIKit


class AppFonts:UIFont{
    private var fontSize:FontsSize?
    private var font:Fonts?
}

extension UIFont {
    enum FontsSize: CGFloat{
        
        case size10 = 10
        case size12 = 12
        case size14 = 14
        case size16 = 16
        case size20 = 20
        case size24 = 24
        case size30 = 30
        case size32 = 32
        case size36 = 36
        
    }
    
    enum FontName:String {
        case light = "Poppins-Light"
        case regular = "Poppins-Regular"
        case medium =  "Poppins-Medium"
        case semiBold = "Poppins-SemiBold"
    }
    
//    var weight:Int {
//        switch self {
//        case .light:
//            return 300
//        case .regular:
//            return 400
//        case .medium:
//            return 500
//        case .semiBold:
//            return 600
//        }
//    }

    enum Fonts{
        
        // UI Element Fonts
        case mainButton // 16-600
        case textFieldTitle // 14-500
        case textFieldText // 12-300
        
        case title24 // 24-500-Medium
        case signUpTitle // 14-600 - SemiBold
        
        case title30 // 30-600
        case cityText16 // 16-300
        
        // for map
        case header24 // 24-600
        case label14 // 14-300
        
        //case detailCityTitle // 30-600 //title30
        case dateText // 14-400
        case creatorText // 10-400
        case descriptionLabel // 12-400
        
//        case mapAddPhotoText // 12-300
        
        // HOMEVC
        case sectionTitle // 20-500
        //case sectionButton // 14-300 //label14
        
        // settings
        case profileNameTitle //16-600
        case profileButton //12-400 // descriptionLabel
        //case settingsLabel // 14-300 //label14
        
        // security settings
        // same as textFields
        
        // Edit Profile
        // same button in settings
        case profileLabel // 12-500
        
        // FAQ
        case descriptionText // 10-300
        
        // Page Headers
        case pageHeader32 // 32-600
        case pageHeader36 // 36-600
        
//        case light(size:FontsSize)
//        case regular(size:FontsSize)
//        case medium(size:FontsSize)
//        case semiBold(size:FontsSize)
        
        // return UIFont(name: FontName.light.rawValue, size: FontsSize.size32.rawValue)
        var font: UIFont! {
            switch self {
            case .mainButton:
                return getFont(name: .semiBold, .size16)
            case .textFieldTitle:
                return getFont(name: .medium, .size14)
            case .textFieldText:
                return getFont(name: .light, .size12)
            case .title24:
                return getFont(name: .medium, .size24)
            case .signUpTitle:
                return getFont(name: .semiBold, .size14)
            case .title30:
                return getFont(name: .semiBold, .size30)
            case .cityText16:
                return getFont(name: .light, .size16)
            case .header24:
                return getFont(name: .semiBold, .size24)
            case .label14:
                return getFont(name: .light, .size14)
            case .dateText:
                return getFont(name: .regular, .size14)
            case .creatorText:
                return getFont(name: .regular, .size10)
            case .descriptionLabel:
                return getFont(name: .regular, .size12)
            case .sectionTitle:
                return getFont(name: .medium, .size20)
            case .profileNameTitle:
                return getFont(name: .semiBold, .size16)
            case .profileButton:
                return getFont(name: .regular, .size12)
            case .profileLabel:
                return getFont(name: .medium, .size12)
            case .descriptionText:
                return getFont(name: .light, .size10)
            case .pageHeader32:
                return getFont(name: .semiBold, .size32)
            case .pageHeader36:
                return getFont(name: .semiBold, .size36)
            }
        }
        
        func getFont(name:FontName, _ size:FontsSize) -> UIFont{
         
            let font = UIFont(name: name.rawValue, size: size.rawValue)!
            return font
        }

    }
    
//    init (font:Fonts){
//        super.init(frame: .zero)
//        self.fontSize = fontSize
//        self.font = font
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
