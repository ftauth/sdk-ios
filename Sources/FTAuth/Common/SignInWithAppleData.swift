//
//  SignInWithAppleData.swift
//  FTAuth
//
//  Created by Dillon Nys on 2/9/21.
//

import Foundation
import AuthenticationServices

enum AppleCredentialType: String {
    case appleID = "apple_id"
    case password = "password"
}

class SignInWithAppleData: NSObject {
    let credentialType: AppleCredentialType
    let userID: String?
    let authCode: Data?
    let scopes: [String]?
    let idToken: Data?
    let email: String?
    let firstName: String?
    let lastName: String?
    let realUserStatus: Int?
    let username: String?
    let password: String?
    
    @available(iOS 13.0, *)
    init(credential: ASAuthorizationAppleIDCredential) {
        self.credentialType = .appleID
        self.userID = credential.user
        self.authCode = credential.authorizationCode
        self.scopes = credential.authorizedScopes.compactMap { $0.rawValue }
        self.idToken = credential.identityToken
        self.email = credential.email
        self.firstName = credential.fullName?.givenName
        self.lastName = credential.fullName?.familyName
        self.realUserStatus = credential.realUserStatus.rawValue
        
        self.username = nil
        self.password = nil
        super.init()
    }
    
    @available(iOS 12.0, *)
    init(credential: ASPasswordCredential) {
        self.credentialType = .password
        self.username = credential.user
        self.password = credential.password
        
        self.userID = nil
        self.authCode = nil
        self.scopes = nil
        self.idToken = nil
        self.email = nil
        self.firstName = nil
        self.lastName = nil
        self.realUserStatus = nil
        super.init()
    }
}
