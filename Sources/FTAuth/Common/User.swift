//
//  UserData.swift
//  FTAuth
//
//  Created by Dillon Nys on 2/5/21.
//

import Foundation

public class User: NSObject {
    let ID: String
    let username: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let phoneNumber: String?
    let provider: String?
    
    public init(ID: String, username: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, phoneNumber: String? = nil, provider: String? = nil) {
        self.ID = ID
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.provider = provider
    }
    
    public override var description: String {
        "User{ID: \(ID)}"
    }
}
