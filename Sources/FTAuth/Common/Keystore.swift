//
//  FTAuthKeychain.swift
//  FTAuth
//
//  Created by Dillon Nys on 1/31/21.
//

import Foundation

public class Keystore: NSObject {
    private let service: Data = "ftauth".data(using: .utf8)!
    
    public enum KeystoreError: Error {
        case keyNotFound(_ key: String? = nil)
        case unknown(_ details: String? = nil)
        case access(_ details: String? = nil)
    }
    
    func errorFor(_ keyStoreError: KeystoreError) -> Error {
        return keyStoreError
    }
    
    func details(for status: OSStatus) -> String? {
        var details: String? = ""
        if #available(iOS 11.3, *) {
            details = SecCopyErrorMessageString(status, nil) as String?
        }
        return details
    }
    
    @objc public func get(_ key: Data?) throws -> Data {
        guard let key = key else {
            throw errorFor(KeystoreError.keyNotFound())
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnAttributes as String: kCFBooleanTrue!,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccount as String: key,
        ]
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        switch status {
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let data = queriedItem[kSecValueData as String] as? Data else {
                throw errorFor(KeystoreError.unknown("Malformed data"))
            }
            
            return data
        case errSecItemNotFound:
            let keyStr = String(data: key, encoding: .utf8)
            throw errorFor(KeystoreError.keyNotFound(keyStr))
        default:
            throw errorFor(KeystoreError.unknown(details(for: status)))
        }
    }
    
    @objc public func save(_ key: Data?, value: Data?) throws {
        guard let key = key else {
            throw errorFor(KeystoreError.keyNotFound())
        }
        
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[kSecValueData as String] = value
            
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw errorFor(KeystoreError.unknown(details(for: status)))
            }
        case errSecItemNotFound:
            query[kSecValueData as String] = value
            
            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw errorFor(KeystoreError.unknown(details(for: status)))
            }
        default:
            throw errorFor(KeystoreError.unknown(details(for: status)))
        }
    }
    
    @objc(clear:) public func clear() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        switch status {
        case errSecSuccess:
            return
        case errSecItemNotFound:
            return
        default:
            throw errorFor(KeystoreError.unknown(details(for: status)))
        }
    }
    
    @objc public func delete(_ key: Data?) throws {
        guard let key = key else {
            throw errorFor(KeystoreError.keyNotFound())
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        switch status {
        case errSecSuccess:
            return
        case errSecItemNotFound:
            return
        default:
            throw errorFor(KeystoreError.unknown(details(for: status)))
        }
    }
}
