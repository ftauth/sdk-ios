//
//  SecurityConfiguration.swift
//  FTAuth
//
//  Created by Dillon Nys on 2/7/21.
//

import Foundation

public class SecurityConfiguration: NSObject {
    public var host: String = ""
    public var trustPublicPKI: Bool = true
    
    public override var hash: Int {
        return host.hash ^ trustPublicPKI.hashValue
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? SecurityConfiguration else {
            return false
        }
        
        return object.host == host && object.trustPublicPKI == trustPublicPKI
    }
}
