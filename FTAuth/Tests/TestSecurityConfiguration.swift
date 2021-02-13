//
//  TestSecurityConfiguration.swift
//  FTAuth-Unit-Tests
//
//  Created by Dillon Nys on 2/7/21.
//

import XCTest
import FTAuth

class TestSecurityConfiguration: XCTestCase {
    private let client = FTAuthClient.shared

    override func setUpWithError() throws {
        if !client.isInitialized {
            try client.initialize(withConfig: FTAuthConfig(gatewayURL: "http://localhost:8080", clientID: "12345", clientSecret: "", clientType: "public", redirectURI: "http://localhost:8000/auth", scopes: ["default"], timeout: 30))
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetDefaultSecurityConfiguration() throws {
        var defaultConfig = client.getDefaultSecurityConfiguration()
        XCTAssert(defaultConfig.trustPublicPKI == true)
        
        let secConf = SecurityConfiguration(host: "", trustSystemRoots: false)
        client.setDefaultSecurityConfiguration(secConf)
        defaultConfig = client.getDefaultSecurityConfiguration()
        XCTAssert(defaultConfig.trustPublicPKI == false)
    }

}
