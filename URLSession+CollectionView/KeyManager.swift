//
//  KeyManager.swift
//  URLSession+CollectionView
//
//  Created by 양호준 on 2023/10/18.
//

import Foundation

struct KeyManager {
    static let shared = KeyManager()
    
    private init() { }
    
    var accessKey: String {
        guard let accessKey = Bundle.main.infoDictionary?["AccessKey"] as? String else {
            return ""
        }
        
        return accessKey
    }
    
    var secretKey: String {
        guard let secretKey = Bundle.main.infoDictionary?["SecretKey"] as? String else {
            return ""
        }
        
        return secretKey
    }
}
