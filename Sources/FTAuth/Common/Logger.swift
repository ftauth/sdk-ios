//
//  Logger.swift
//  FTAuth
//
//  Created by Dillon Nys on 2/13/21.
//

import Foundation

/// Prints logs to stdout.
class DefaultLogger: NSObject {
    func debug(_ log: String?) {
        print("[DEBUG]: \(log ?? "nil")", terminator: "")
    }
    
    func error(_ log: String?) {
        print("[ERROR]: \(log ?? "nil")", terminator: "")
    }
    
    func info(_ log: String?) {
        print("[INFO]: \(log ?? "nil")", terminator: "")
    }
    
    func warn(_ log: String?) {
        print("[WARN]: \(log ?? "nil")", terminator: "")
    }
}
