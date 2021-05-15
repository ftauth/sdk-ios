//
//  FTAuthLogger.swift
//  FTAuth
//
//  Created by Dillon Nys on 1/31/21.
//

import Foundation
import FTAuthInternal

/// Defines an interface for logging within the FTAuth library. Users should implement this
/// to define custom logging behavior within the library. By default, all logs are printed to stdout.
@objc public protocol FTAuthLogger: FtauthinternalLoggerProtocol {}

extension DefaultLogger: FTAuthLogger {}
