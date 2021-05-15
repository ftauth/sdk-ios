//
//  SecurityConfiguration+FTAuthInternal.swift
//  FTAuth
//
//  Created by Dillon Nys on 2/7/21.
//

import Foundation
import FTAuthInternal

extension SecurityConfiguration {
    @objc public convenience init(host: String, trustPublicPKI: Bool = false) {
        self.init()
        self.host = host
        self.trustPublicPKI = trustPublicPKI
        FtauthinternalGetCertificateRepository()!.add(FtauthinternalNewSecurityConfiguration(host, trustPublicPKI))
    }
    
    @objc public func addIntermediatePEM(data: Data) throws {
        let internalConf = FtauthinternalGetCertificateRepository()!.getSecurityConfiguration(host)
        try internalConf!.addIntermediatePEM(data)
    }
    
    @objc public func addIntermediateASN1(data: Data) throws {
        let internalConf = FtauthinternalGetCertificateRepository()!.getSecurityConfiguration(host)
        try internalConf!.addIntermediateASN1(data)
    }
}
