//
//  Config.swift
//  FTAuth
//
//  Created by Dillon Nys on 2/7/21.
//

import Foundation

public class FTAuthConfig: NSObject, Codable {
    let gatewayURL: String
    let clientID: String
    let clientSecret: String?
    let clientType: String
    let redirectURI: String
    let scopes: [String]
    let timeout: Int
    
    @objc public init(gatewayURL: String, clientID: String, clientSecret: String?, clientType: String, redirectURI: String, scopes: [String], timeout: Int) {
        self.gatewayURL = gatewayURL
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.clientType = clientType
        self.redirectURI = redirectURI
        self.scopes = scopes
        self.timeout = timeout
        super.init()
    }
    
    public enum CodingKeys: String, CodingKey  {
        case gatewayURL = "gateway_url"
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case clientType = "client_type"
        case redirectURI = "redirect_uri"
        case scopes = "scopes"
        case timeout = "timeout"
    }
}
