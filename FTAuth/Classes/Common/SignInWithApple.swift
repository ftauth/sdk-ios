//
//  SignInWithApple.swift
//  FTAuth
//
//  Created by Dillon Nys on 2/9/21.
//

import Foundation
import AuthenticationServices

typealias SignInWithAppleCompletionHandler = (SignInWithAppleData?, Error?) -> Void

@available(iOS 13.0, *)
class SignInWithApple: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var completion: SignInWithAppleCompletionHandler?
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userData = SignInWithAppleData(credential: appleIDCredential)
            
            completion?(userData, nil)
            completion = nil
        
        case let passwordCredential as ASPasswordCredential:
            let userData = SignInWithAppleData(credential: passwordCredential)
            
            completion?(userData, nil)
            completion = nil
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(nil, error)
        completion = nil
    }
    
    func getStatus(for userID: String, completion: @escaping (ASAuthorizationAppleIDProvider.CredentialState, Error?) -> Void) {
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userID, completion: completion)
    }
    
    /// Prompts the user with the Sign In With Apple login.
    func login(completion: SignInWithAppleCompletionHandler?) {
        self.completion = completion
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        // Create an authorization controller with the given requests
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    /// Prompts the user if an existing iCloud Keychain credential or Apple iD credential exists.
    func performExistingAccountSetupFlow() {
        // Prepare requests for both Apple ID and password providers
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
