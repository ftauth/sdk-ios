//
//  FTAuthKeychain.swift
//  FTAuth
//
//  Created by Dillon Nys on 1/31/21.
//

import Foundation
import KeychainAccess

public class Keystore: NSObject {
    private let keychain = Keychain(service: "io.ftauth")
    
    public enum KeystoreError: Error {
        case keyNotFound(_ key: String? = nil)
        case unknown(_ details: String? = nil)
        case access(_ details: String? = nil)
    }
    
    func errorFor(_ keyStoreError: KeystoreError) -> Error {
        return keyStoreError
    }
    
    @objc public func get(_ key: String?) throws -> Data {
        guard let key = key else {
            throw errorFor(KeystoreError.keyNotFound())
        }
        
        var data: Data?
        do {
            data = try keychain.getData(key)
        } catch {
            throw errorFor(KeystoreError.unknown(error.localizedDescription))
        }
        
        guard let data = data else {
            throw errorFor(KeystoreError.keyNotFound(key))
        }
        return data
    }
    
    @objc public func save(_ key: String?, value: Data?) throws {
        guard let key = key else {
            throw errorFor(KeystoreError.keyNotFound())
        }
        guard let value = value else {
            throw errorFor(KeystoreError.unknown("Value cannot be empty"))
        }
        
        do {
            try keychain.set(value, key: key)
        } catch {
            throw errorFor(KeystoreError.unknown(error.localizedDescription))
        }
    }
    
    @objc(clear:) public func clear() throws {
        do {
            try keychain.removeAll()
        } catch {
            throw errorFor(KeystoreError.unknown(error.localizedDescription))
        }
    }
    
    @objc public func delete(_ key: String?) throws {
        guard let key = key else {
            throw errorFor(KeystoreError.keyNotFound())
        }
        
        do {
            try keychain.remove(key)
        } catch {
            throw errorFor(KeystoreError.unknown(error.localizedDescription))
        }
    }
}
