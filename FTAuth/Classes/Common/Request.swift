//
//  Request.swift
//  FTAuth
//
//  Created by Dillon Nys on 1/31/21.
//

import Foundation

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public struct HttpRequest {
    let method: HttpMethod
    let url: String
    let body: Data?
    
    public init(method: HttpMethod, url: String, body: Data?) {
        self.method = method
        self.url = url
        self.body = body
    }
}
