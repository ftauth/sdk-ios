//
//  Error.swift
//  FTAuth
//
//  Created by Dillon Nys on 2/13/21.
//

import Foundation

public enum FTAuthErrorCode: String {
    case invalidArguments = "INVALID_ARGUMENTS"
    case auth = "AUTH"
    case authCancelled = "AUTH_CANCELLED"
    case authUnknown = "AUTH_UNKNOWN"
    case keystoreAccess = "KEYSTORE_ACCESS"
    case keystoreUnknown = "KEYSTORE_UNKNOWN"
    case keyNotFound = "KEY_NOT_FOUND"
    case unknown = "UNKNOWN"
    case unsupportedPlatform = "UNSUPPORTED_PLATFORM"
    case uninitialized = "UNINITIALIZED"
    case couldNotInitialize = "INITIALIZATION_ERROR"
}

public struct FTAuthError: Error, CustomStringConvertible {
    public let errorCode: FTAuthErrorCode
    public let details: String?
    
    public static let unknown = FTAuthError(errorCode: .unknown)
    
    public init(errorCode: FTAuthErrorCode, details: String? = nil) {
        self.errorCode = errorCode
        self.details = details
    }
    
    public var description: String {
        switch errorCode {
        case .invalidArguments:
            return "Invalid arguments"
        case .authCancelled:
            return "Authentication process cancelled"
        case .authUnknown:
            return "An unknown error occurred authenticating the user"
        case .unknown:
            return "An unknown error occurred"
        case .unsupportedPlatform:
            return "FTAuth is not supported on this platform"
        case .uninitialized:
            return "FTAuth must be initialized first"
        case .couldNotInitialize:
            return "An error occurred initializing FTAuth"
        case .keystoreAccess:
            return "There was an error accessing the Keychain"
        case .keystoreUnknown:
            return "An unknown error occurred using the Keychain"
        case .keyNotFound:
            return "The key was not found in the Keychain"
        case .auth:
            return "An authentication error occurred"
        }
    }
}
