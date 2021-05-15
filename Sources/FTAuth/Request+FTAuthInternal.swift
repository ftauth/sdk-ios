//
//  Request.swift
//  FTAuth
//
//  Created by Dillon Nys on 1/31/21.
//

import Foundation
import FTAuthInternal

public extension HttpRequest {
    var ftauthRequest: FtauthinternalRequest? {
        return FtauthinternalNewRequest(method.rawValue, url, body)
    }
}

public extension FtauthinternalClient {
    func request(_ httpRequest: HttpRequest) throws -> FtauthinternalResponse {
        return try request(httpRequest.ftauthRequest)
    }
}
