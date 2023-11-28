//
//  KeychainHelper.swift
//  TravioApp
//
//  Created by web3406 on 10/30/23.
//
import Foundation


final class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    private let service: String = "travio"
    private let account: String = "email"
    
    ///Store tokens obtained via LoginVC
    var userToken = Tokens(accessToken: "", refreshToken: "") // logindeki tokenleri tutuyor.
    
    /// Returns access token from Keychain in String format
    func getToken() -> String? {
        if let tokenData = self.read(service: service, account: account) {
            return String(data: tokenData, encoding: .utf8)
        }
        return nil
    }
    
    /// Sets user token into Keychain
    func setToken(param: Tokens) {
        if let accessToken = saveAccessToken(service: service, account: account, token: param.accessToken) {
            userToken.accessToken = accessToken
        }
    }
    
    func deleteToken() {
        self.delete(service: service, account: account)
    }
    
    /// Method to check that if tıken is expired
    func isTokenExpired() -> Bool {
        guard let token = getToken(),
              let payload = decodeJwtToken(token: token) else {return true}
        
        guard let exp = payload["exp"] as? TimeInterval else {return true}
        
        return Date().timeIntervalSince1970 > exp
    }
    
    func isUserLoggedIn() -> Bool {
        return !userToken.accessToken.isEmpty // Kullanıcı token'ı doluysa oturum açık kabul edilsin
    }
    
    /// Method to decode accessToken and get token expiration time
    private func decodeJwtToken(token: String) -> [String: Any]? {
        let segments = token.components(separatedBy: ".")
        guard segments.count > 1 else {return nil}
        
        let base64String = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let padded = base64String.padding(toLength: ((base64String.count + 3) / 4)*4, withPad: "=", startingAt: 0)
        
        guard let data = Data(base64Encoded: padded) else {return nil}
        return try? JSONSerialization.jsonObject(with: data) as? [String:Any]
    }
    
    private func saveAccessToken(service: String, account: String, token: String) -> String? {
        let tokenData = token.data(using: .utf8)
        
        let query = [
            kSecValueData: tokenData!,
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
        return token
    }
    
    private func read(service:String,account:String)->Data? {
        
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
    
    private func delete(service:String, account:String){
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        SecItemDelete(query)
    }
    
    private func getAllKeyChainItemsOfClass(_ secClass: String) -> [String:String] {
        
        let query: [String: Any] = [
            kSecClass as String : secClass,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecReturnAttributes as String : kCFBooleanTrue!,
            kSecReturnRef as String : kCFBooleanTrue!,
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

extension KeychainHelper {
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
}
