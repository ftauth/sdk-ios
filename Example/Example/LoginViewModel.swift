//
//  LoginViewModel.swift
//  Example
//
//  Created by Dillon Nys on 2/5/21.
//

import Foundation
import FTAuth

class LoginViewModel {
    static let shared = LoginViewModel()
    let client = FTAuthClient.shared
    
    private init() {}
    
    func initialize() {
        do {
            try client.initialize()
        } catch {
            print("Error initializing FTAuth: \(error.localizedDescription)")
        }
    }
    
    func login(completion: @escaping (User?, Error?) -> Void) {
        client.login(completion: completion)
    }
    
    func signInWithApple(completion: @escaping (User?, Error?) -> Void) {
        client.login(provider: .apple, completion: completion)
    }
}
