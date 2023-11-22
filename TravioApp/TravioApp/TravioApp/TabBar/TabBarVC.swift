//
//  TabBarVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 30.10.2023.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func mainViewControllerDidLogout()
}

class TabBarVC: UITabBarController {
    
    // MARK: Properties
    
    weak var delegateCoord: MainViewControllerDelegate?
    var viewModel: TabBarVM = TabBarVM()
    
    private lazy var AppButton:UIButton = {
        let b = UIButton()
        
        return b
    }()
    
    deinit {
        print("dealloc \(self)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = setupTabControllers()
        // tab bar default view
        self.selectedIndex = 0
        // text color of Tab Bar elements
        self.tabBar.tintColor = UIColor(named: "backgroundColor")
        // image color of Tab Bar elements when not selected
        self.tabBar.unselectedItemTintColor = .systemGray
        // set transparancy
        self.tabBar.isTranslucent = false
        // set background color for tint
        self.tabBar.backgroundColor = UIColor(named: "textColorReversed")
        // hide backButton
        self.navigationItem.setHidesBackButton(true, animated: false)

        self.delegateCoord = viewModel
        self.title = "Main"
    }
    
    // 4 buton olacak: Home, visits, map, menu
    private func setupTabControllers()->[UIViewController]
    {
        let homeVC = HomeVC()
        let homeNC = UINavigationController(rootViewController: homeVC)
        let homeImage = UIImage(named: "home") // image when not selected
        let homeSelectedImage = UIImage(named: "home")?.withRenderingMode(.automatic) // image when active page
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: homeImage, selectedImage: homeSelectedImage)
        
        let visitsVC = VisitsVC()
        let visitsNC = UINavigationController(rootViewController: visitsVC)
        let visitsImage = UIImage(named: "mapPin")
        let visitsSelectedImage = UIImage(named: "mapPin")?.withRenderingMode(.automatic)
        visitsVC.tabBarItem = UITabBarItem(title: "Visits", image: visitsImage, selectedImage: visitsSelectedImage)
        
        let mapVC = MapVC()
        let mapNC = UINavigationController(rootViewController: mapVC)
        let mapImage = UIImage(named:"map")
        let mapSelectedImage = UIImage(named: "map")?.withRenderingMode(.automatic)
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: mapImage, selectedImage: mapSelectedImage)
        
        let menuVC = SettingsVC()
        let menuNC = UINavigationController(rootViewController: menuVC)
        let menuImage = UIImage(named: "list")
        let menuSelectedImage = UIImage(named: "list")?.withRenderingMode(.automatic)
        menuVC.tabBarItem = UITabBarItem(title: "Menu", image: menuImage, selectedImage: menuSelectedImage)
        
        return [homeNC, visitsNC, mapNC, menuNC]
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct TabBarVC_Preview: PreviewProvider {
    static var previews: some View{
        
        TabBarVC().showPreview()
    }
}
#endif
