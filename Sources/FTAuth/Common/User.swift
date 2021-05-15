//
//  UserData.swift
//  FTAuth
//
//  Created by Dillon Nys on 2/5/21.
//

import Foundation

public class User: NSObject {
    public let ID: String
    public let username: String?
    public let firstName: String?
    public let lastName: String?
    public let email: String?
    public let phoneNumber: String?
    public let provider: String?
    
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
