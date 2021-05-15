//
//  KeyStore.swift
//  FTAuthKit
//
//  Created by Dillon Nys on 1/31/21.
//

import Foundation
import FTAuthInternal

class FTAuthKeyStore: Keystore, FtauthinternalKeyStoreProtocol {
    override func errorFor(_ keyStoreError: KeystoreError) -> Error {
        var err: NSError?
        
        switch keyStoreError{
        case .access(let details):
            FtauthinternalErrAccess(details, &err)
        case .keyNotFound(let key):
            FtauthinternalErrKeyNotFound(key, &err)
        case .unknown(let details):
            FtauthinternalErrUnknown(details, &err)
        }
        
        return err ?? NSError(domain: "FTAuth", code: -1, userInfo: nil)
    }
}
