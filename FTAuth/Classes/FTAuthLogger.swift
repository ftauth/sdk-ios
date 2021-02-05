//
//  FTAuthLogger.swift
//  FTAuth
//
//  Created by Dillon Nys on 1/31/21.
//

import Foundation
import FTAuthInternal

class FTAuthLogger: NSObject, FtauthinternalLoggerProtocol {
    func write(_ p0: Data?, n: UnsafeMutablePointer<Int>?) throws {
        if let size = p0?.count {
            n?.initialize(to: size)
        }
        if let data = p0 {
            print(String(data: data, encoding: .utf8) ?? "Invalid log")
        }
    }
}
