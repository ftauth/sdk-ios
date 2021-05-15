//
//  SignInWithApple+FTAuthInternal.swift
//  FTAuth
//
//  Created by Dillon Nys on 2/9/21.
//

import Foundation
import FTAuthInternal

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension SignInWithApple {
    func login(handler: FtauthinternalSignInWithAppleProtocol, completion: AuthenticationCompletionHandler?) {
        self.login { (user: SignInWithAppleData?, error: Error?) in
            if let error = error {
                completion?(nil, error)
                return
            }
            guard let user = user else {
                completion?(nil, AuthenticationError.unknown("Empty sign in data"))
                return
            }
            
            do {
                var internalSignInData: FtauthinternalSignInWithAppleData?
                switch user.credentialType {
                case .password:
                    internalSignInData = FtauthinternalNewSignInWithApplePasswordData(user.username, user.password)
                case .appleID:
                    internalSignInData = FtauthinternalNewSignInWithAppleIDData(user.userID, user.authCode, user.scopes?.joined(separator: ","), user.idToken, user.email, user.firstName, user.lastName, user.realUserStatus ?? 0)
                }
                let internalUserData = try handler.signIn(withApple: internalSignInData)
                let userData = User(ID: internalUserData.id_, username: internalUserData.username, firstName: internalUserData.firstName, lastName: internalUserData.lastName, email: internalUserData.email, phoneNumber: internalUserData.phoneNumber)
                completion?(userData, nil)
            } catch {
                completion?(nil, error)
            }
        }
    }
}
