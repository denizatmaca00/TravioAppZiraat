//
//  KeychainHelper.swift
//  TravioApp
//
//  Created by web3406 on 10/30/23.
//
import Foundation


final class KeychainHelper {
    
    static let shared = KeychainHelper()
    var userToken = Tokens(accessToken: "", refreshToken: "") // logindeki tokenleri tutuyor.
    
//    func saveUserSession(startTime: Date, duration: TimeInterval) {
//        let sessionData: [String: Any] = [
//            "startTime": startTime,
//            "duration": duration
//        ]
//
//        let encodedData = NSKeyedArchiver.archivedData(withRootObject: sessionData)
//
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: "TravioSession",
//            kSecAttrAccount as String: "UserSession",
//            kSecValueData as String: encodedData
//        ]
//
//        SecItemDelete(query as CFDictionary)
//
//        let status = SecItemAdd(query as CFDictionary, nil)
//        if status != errSecSuccess {
//            print("Error saving session data to Keychain")
//        }
//    }
//
//    func loadUserSession() -> (startTime: Date, duration: TimeInterval)? {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: "TravioSession",
//            kSecAttrAccount as String: "UserSession",
//            kSecMatchLimit as String: kSecMatchLimitOne,
//            kSecReturnData as String: kCFBooleanTrue,
//        ]
//
//        var data: CFTypeRef?
//        let status = SecItemCopyMatching(query as CFDictionary, &data)
//
//        if status == errSecSuccess, let data = data as? Data {
//            if let sessionData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any],
//               let startTime = sessionData["startTime"] as? Date,
//               let duration = sessionData["duration"] as? TimeInterval {
//                return (startTime, duration)
//            }
//        }
//
//        return nil
//    }

    
    func isUserLoggedIn() -> Bool {
        return !userToken.accessToken.isEmpty // Kullanıcı token'ı doluysa oturum açık kabul edilsin
    }

    func getToken() -> String? {
        return userToken.accessToken // Kullanıcının token'ını döndürün dedi chatgbt
    }
    
//    func isUserLoggedIn() -> Bool {
//        print("şu an burası getToken ve muhtelemen girmeyecek")
//           return getToken() != nil
//       }
    
//    func getToken() -> String? {
//        if let data = read(service: "Travio", account: "asd") {
//            print(data)
//            return String(data: data, encoding: .utf8)
//        }
//        return nil
//    }
    
    
    func setToken(param: Tokens) {
        if let accessToken = KeychainHelper.shared.saveAccessToken(service: "travio", account: "email", token: param.accessToken) {
            userToken.accessToken = accessToken
        }
    }
    
    func saveAccessToken(service: String, account: String, token: String) -> String? {
        let tokenData = token.data(using: .utf8)
        
        let query = [
            kSecValueData: tokenData,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: tokenData] as CFDictionary
            
            SecItemUpdate(query, attributesToUpdate)
        }
        //     print(token)
        return token
    }
    
    
    
    func read(service:String,account:String)->Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result:AnyObject?
        SecItemCopyMatching(query, &result)
        
        
        return (result as? Data)
    }
    
    
    func delete(_ service:String, account:String){
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        SecItemDelete(query)
    }
    
    func getAllKeyChainItemsOfClass(_ secClass: String) -> [String:String] {
        
        let query: [String: Any] = [
            kSecClass as String : secClass,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecReturnAttributes as String : kCFBooleanTrue,
            kSecReturnRef as String : kCFBooleanTrue,
            kSecMatchLimit as String : kSecMatchLimitAll
        ]
        
        var result: AnyObject?
        
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        var values = [String:String]()
        if lastResultCode == noErr {
            let array = result as? Array<Dictionary<String, Any>>
            
            for item in array! {
                if let key = item[kSecAttrAccount as String] as? String,
                   let value = item[kSecValueData as String] as? Data {
                    values[key] = String(data: value, encoding:.utf8)
                }
            }
        }
        
        return values
    }
    
}
