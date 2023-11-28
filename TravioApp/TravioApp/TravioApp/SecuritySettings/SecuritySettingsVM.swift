//
//  SecuritySettingsVM.swift
//  TravioApp
//
//  Created by Ece Poyraz on 15.11.2023.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import CoreLocation

class SecuritySettingsVM{
    let locationManager = CLLocationManager()
    var requestPermissionAlertClosure: (() -> Void)?
    var presentClosure: ((UIAlertController) -> Void)?
    
    var checkPermission: (()->())?
    var checkPermissionLibrary: (()->())?
    var checkPermissionLocation: (()->())?
    var checkPermissionStatus: Bool?
    var checkPermissionLocationStatus: Bool?
    var checkPermissionLibraryStatus: Bool?
    var passwordChangeClosure: ((Password)->())?
    var passwordChangeAlertClosure: ((String,String)->Void)?
    func putPassword(password:Password){
        let pass = ["new_password" : password.new_password]
        NetworkingHelper.shared.dataFromRemote(urlRequest: .putPassword(params: pass), callback:{(result:Result<Messages,Error>) in
            switch result{
            case .success(let params):
                print(params)
                self.passwordChangeAlertClosure?("Password Change", "Password Change Success")
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        })
    }
    struct permissionModel{
        var checkPermissionStatus:Bool
        var checkPermissionNonStatus:Bool
    }
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print(" kamera erişim izni \(granted) ")
                self.checkPermissionStatus = true
            } else {
                print("Kullanıcı kamera erişim iznini reddetti.  \(granted)")
                self.checkPermissionStatus = false
            }
        }
    }
    //eğer toggle switch on ise kamera settinge gitmesini istedim, telefondan kapatacağım
        func redirectToAppSettings() {
               let alertController = UIAlertController(
                   title: "Camera Access Required",
                   message: "To enable camera access, please go to Settings and turn on Camera for this app.",
                   preferredStyle: .alert
               )
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
               alertController.addAction(cancelAction)
   
               let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
                   if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                       if UIApplication.shared.canOpenURL(settingsURL) {
                           UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                       }
                   }
               }
               alertController.addAction(openSettingsAction)
               presentClosure?(alertController)
           }

    func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("Photo Library izni verildi.")
                    self.checkPermissionLibraryStatus = true
                case .denied, .restricted:
                    print("Kullanıcı Photo Library erişim iznini reddetti.")
                    self.checkPermissionLibraryStatus = false
                case .notDetermined:
                    print("Photo Library izni henüz belirlenmedi.")
                    //self.photoLibraryPermission()
                    self.checkPermissionLibraryStatus = false
                default:
                    self.checkPermissionLibraryStatus = false
            }
        }
    }
    func photoLibraryToAppSettings(){
        let alert = UIAlertController(
            title: "Photo Library Required", message: "To enable Photo Library access, please go to Settings and turn on Photo Library for this app.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)

        let openSetting = UIAlertAction(title: "open settings", style: .default){ dene in
            if let settingUrl = URL(string: UIApplication.openSettingsURLString){
                if UIApplication.shared.canOpenURL(settingUrl){
                    UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
                }
            }
        }
        alert.addAction(openSetting)
        presentClosure?(alert)
    }
    
    
     func locationToAppSettings(){
         let alert = UIAlertController(
             title: "Location Required", message: "To enable Location access, please go to Settings and turn on Location for this app.", preferredStyle: .alert)
         let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
         alert.addAction(cancel)
 
         let openSetting = UIAlertAction(title: "open settings", style: .default){ dene in
             if let settingUrl = URL(string: UIApplication.openSettingsURLString){
                 if UIApplication.shared.canOpenURL(settingUrl){
                     UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
                 }
             }
         }
         alert.addAction(openSetting)
         presentClosure?(alert)
     }
    func requestLocationPermission() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted.")
            self.checkPermissionLocationStatus = true
        default:
            print("Location access denied.")
            self.checkPermissionLocationStatus = false
        }
    }
     // first photolibrary permission
     func locationPermission() {
        locationManager.requestWhenInUseAuthorization()
        
     }
}
