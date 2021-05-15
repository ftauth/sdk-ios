//
//  ContentViewModel.swift
//  Example
//
//  Created by Dillon Nys on 5/15/21.
//

import Foundation
import FTAuth

class ContentViewModel: ObservableObject {
    private let client = FTAuthClient.shared
    
    @Published var user: User?
    @Published var error: Error?
    
    init() {
        do {
            try client.initialize()
        } catch {
            print("Error initializing FTAuth: \(error.localizedDescription)")
        }
    }
    
    func login() {
        client.login() { user, error in
            DispatchQueue.main.async {
                self.user = user
                self.error = error
            }
        }
    }
}
