//
//  TabBarVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 30.10.2023.
//

import UIKit

class TabBarVC: UITabBarController {
    
    // MARK: Properties
    
    private let queue = DispatchQueue(label: "TokenMonitor")
    private var tokenExpirationTimer: Timer?
    private var tokenExpirationTreshold: TimeInterval = 300
    private let tokenCheckInterval:TimeInterval = 60 // 300 = 60sec * 5min
    
    private lazy var AppButton:UIButton = {
        let b = UIButton()
        
        return b
    }()
    
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
        
        startMonitoringToken()
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

extension TabBarVC {
    
    func startMonitoringToken() {
        
        // Schedule the timer to check token expiry every 5 minutes (adjust the interval as needed)
        tokenExpirationTimer = Timer.scheduledTimer(timeInterval: (tokenCheckInterval), target: self, selector: #selector(checkTokenExpire), userInfo: nil, repeats: true)
    }
    
    @objc func checkTokenExpire(){
        
        if !KeychainHelper.shared.isTokenExpired(){
            if KeychainHelper.shared.remainingSessionTime! < tokenExpirationTreshold {
                // TODO: Show alert
                
                print("token is about to expire. Do you want to extend your session?")
                showTokenAboutToExpireAlert(timeRemaining: KeychainHelper.shared.remainingSessionTime!)
                // TODO: Refresh access token
                KeychainHelper.shared.logout(completion: {_ in
                    
                    KeychainHelper.shared.logout { result in
                        switch result {
                        case .success:
                            let loginVC = LoginVC()
                            let navigationController = UINavigationController(rootViewController: loginVC)
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController = navigationController
                            }
                            
                        case .failure(_):
                            return
                        }
                    }
                })
                
            } else {
                print("Token expired. Proceeding to Login")
            }
        } else {
            print("token is still valid. Time: \(tokenExpirationTimer!.timeInterval.stringFormatted())")
        }
    }
    
    func showTokenAboutToExpireAlert(timeRemaining: TimeInterval) {
        // Show an alert to inform the user that the token is about to expire
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        
        let alert = UIAlertController(title: "Token Expiring Soon", message: "Your session will expire in \(minutes) minutes and \(seconds) seconds. Please renew your token.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
