//
//  WebViewLauncher.swift
//  FTAuth
//
//  Created by Dillon Nys on 1/31/21.
//

import Foundation
import AuthenticationServices
import Combine
import SafariServices

public typealias AuthenticationCompletionHandler = (User?, Error?) -> Void

public enum AuthenticationError: Error {
    case auth(error: String, errorDescription: String?, errorURI: String?)
    case cancelled
    case unknown(_ details: String? = nil)
}

public protocol WebViewLauncher {
    func launchURL(_ url: String?, completion: @escaping ([String: String]?, Error?) -> Void)
}

func processParameters(_ callbackURL: URL?) -> ([String: String]?, Error?) {
    if let callbackURL = callbackURL {
        let urlComponents = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true)
        if let queryParameters = urlComponents?.queryItems, let state = queryParameters.first(where: { $0.name == "state" })?.value {
            if let code = queryParameters.first(where: { $0.name == "code" })?.value  {
                return (["code": code, "state": state], nil)
            } else if let error = queryParameters.first(where: { $0.name == "error" })?.value {
                let errDesc = queryParameters.first(where: { $0.name == "error_description" })?.value
                let errUri = queryParameters.first(where: { $0.name == "error_uri" })?.value
                let err = AuthenticationError.auth(error: error, errorDescription: errDesc, errorURI: errUri)
                return (["state": state], err)
            }
        }
    }
    return (nil, AuthenticationError.unknown("Invalid callback URL: \(callbackURL?.absoluteString ?? "nil")"))
}

@available(iOS 12.0, macOS 10.15, macCatalyst 13.0, watchOS 6.2, *)
public class AuthenticationSession: NSObject, WebViewLauncher {
    // Strong reference for iOS 12 (see session.start)
    private var session: ASWebAuthenticationSession?
    
    public func launchURL(_ url: String?, completion: @escaping ([String: String]?, Error?) -> Void) {
        guard let url = url, let uri = URL(string: url) else {
            completion(nil, AuthenticationError.unknown("Invalid URL"))
            return
        }
        session = ASWebAuthenticationSession(url: uri, callbackURLScheme: "myapp") { callbackURL, error in
            if error != nil {
                // Will only return error if cancelled.
                completion(nil, AuthenticationError.cancelled)
                return
            }
            let (queryParams, error) = processParameters(callbackURL)
            completion(queryParams, error)
        }

        #if !os(watchOS)
        if #available(iOS 13.0, *) {
            session!.presentationContextProvider = self
            session!.prefersEphemeralWebBrowserSession = true
        }
        #endif
        
        DispatchQueue.main.async {
            self.session!.start()
        }
    }
    
    @available(iOS 13.0, *)
    public func launchURL(_ url: String) -> Future<[String: String], Error> {
        return Future<[String: String], Error> { promise in
            self.launchURL(url) { queryParams, error in
                if let queryParams = queryParams {
                    promise(.success(queryParams))
                } else {
                    promise(.failure(error ?? AuthenticationError.unknown()))
                }
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, macCatalyst 13.0, *)
@available(watchOS, unavailable)
extension AuthenticationSession: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

@available(iOS, introduced: 11.0)
@available(iOS, deprecated: 12.0)
@available(macCatalyst, introduced: 13.0)
@available(macCatalyst, deprecated: 13.0)
public class AuthenticationSessionCompat: NSObject, WebViewLauncher {
    private var session: SFAuthenticationSession?
    
    public func launchURL(_ url: String?, completion: @escaping ([String : String]?, Error?) -> Void) {
        guard let url = url, let uri = URL(string: url) else {
            completion(nil, AuthenticationError.unknown("Invalid URL"))
            return
        }
        session = SFAuthenticationSession(url: uri, callbackURLScheme: "myapp") { callbackURL, error in
            if error != nil {
                // Will only return error if cancelled.
                completion(nil, AuthenticationError.cancelled)
                return
            }
            let (queryParams, error) = processParameters(callbackURL)
            completion(queryParams, error)
        }
        
        DispatchQueue.main.async {
            self.session!.start()
        }
    }
}
