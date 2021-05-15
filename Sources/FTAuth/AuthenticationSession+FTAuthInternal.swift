//
//  FTAuthWebViewLauncher.swift
//  FTAuth
//
//  Created by Dillon Nys on 1/31/21.
//

import Foundation
import FTAuthInternal

private func launchURL(_ launcher: WebViewLauncher, url: String?, completer: FtauthinternalAuthorizationCodeCompleterProtocol?) {
    guard let url = url, let completer = completer else {
        return
    }
    DispatchQueue.global(qos: .userInitiated).async {
        launcher.launchURL(url) { queryParams, error in
           if let error = error {
                if let queryParams = queryParams {
                    let authResp = FtauthinternalNewAuthorizationCodeResponse(nil, queryParams["state"], error)
                    completer.complete(authResp, err: nil)
                } else {
                    completer.complete(nil, err: error)
                }
               return
           }
           guard let queryParams = queryParams else {
            completer.complete(nil, err: AuthenticationError.unknown())
               return
           }
           let authResp = FtauthinternalNewAuthorizationCodeResponse(queryParams["code"], queryParams["state"], nil)
           completer.complete(authResp, err: nil)
       }
    }
}

@available(iOS 12.0, macOS 10.15, macCatalyst 13.0, watchOS 6.2, *)
extension AuthenticationSession: FtauthinternalWebViewLauncherProtocol {
    public func launchURL(_ url: String?, completer: FtauthinternalAuthorizationCodeCompleterProtocol?) {
        FTAuth.launchURL(self, url: url, completer: completer)
    }
}

#if os(iOS)
@available(iOS, introduced: 11.0)
@available(iOS, deprecated: 12.0)
@available(macCatalyst, introduced: 13.0)
@available(macCatalyst, deprecated: 13.0)
extension AuthenticationSessionCompat: FtauthinternalWebViewLauncherProtocol {
    public func launchURL(_ url: String?, completer: FtauthinternalAuthorizationCodeCompleterProtocol?) {
        FTAuth.launchURL(self, url: url, completer: completer)
    }
}
#endif
