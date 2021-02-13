import FTAuthInternal

public class FTAuthClient: NSObject {
    @objc public static let shared = FTAuthClient()
    private var internalClient: FtauthinternalClient?
    private let keystore = FTAuthKeyStore()
    private let certRepo = FtauthinternalGetCertificateRepository()!
    
    public var isInitialized: Bool {
        internalClient != nil
    }
    
    @objc public func initialize(withJSON configJSON: Data) throws {
        try keystore.clear()
        
        var optionsErr: NSError?
        let options = FtauthinternalNewClientOptions(keystore, FTAuthLogger(), configJSON, &optionsErr)
        if let optionsErr = optionsErr {
            throw FTAuthError(errorCode: .couldNotInitialize, details: optionsErr.localizedDescription)
        }
        
        var clientErr: NSError?
        let client = FtauthinternalNewClient(options, &clientErr)
        if let clientErr = clientErr {
            throw FTAuthError(errorCode: .couldNotInitialize, details: clientErr.localizedDescription)
        }
        guard let internalClient = client else {
            throw FTAuthError(errorCode: .couldNotInitialize)
        }
        
        self.internalClient = internalClient
    }
    
    @objc public func initialize(withConfig config: FTAuthConfig) throws {
        let json = try JSONEncoder().encode(config)
        return try initialize(withJSON: json)
    }
    
    @objc public func initialize(withURL url: URL) throws {
        let configJSON = try Data(contentsOf: url)
        return try initialize(withJSON: configJSON)
    }
    
    @objc public func initialize() throws {
        guard let url = Bundle.main.url(forResource: "ftauth_config.json", withExtension: nil) else {
            throw FTAuthError(errorCode: .couldNotInitialize, details: "Could not find configuration file: ftauth_config.json")
        }
        return try initialize(withURL: url)
    }
    
    @objc public func login(provider: Provider = .ftauth, completion: AuthenticationCompletionHandler? = nil) {
        guard let internalClient = internalClient else {
            completion?(nil, FTAuthError(errorCode: .uninitialized))
            return
        }
        
        // Special Sign In With Apple case. Since this is mostly all handled by Apple,
        // the flow is different from the typical OAuth flow.
        //
        // Note that for iOS 12, Sign In With Apple is available but **does** follow the
        // typical OAuth flow below.
        if provider == .apple, #available(iOS 13.0, *) {
            DispatchQueue.global(qos: .userInitiated).async {
                SignInWithApple().login(handler: internalClient, completion: completion)
            }
            return
        }
        
       
        if #available(iOS 12.0, macOS 10.15, macCatalyst 13.0, watchOS 6.2, *) {
            DispatchQueue.global(qos: .userInitiated).async {
                internalClient.login(provider.rawValue, webView: AuthenticationSession(), completion: LoginCompleter(completion: completion))
            }
            return
        }
        
        #if !os(watchOS)
        if #available(iOS 11.0, *) {
            DispatchQueue.global(qos: .userInitiated).async {
                internalClient.login(provider.rawValue, webView: AuthenticationSessionCompat(), completion: LoginCompleter(completion: completion))
            }
            return
        }
        #endif
            
        completion?(nil, FTAuthError(errorCode: .unsupportedPlatform))
    }
    
    @objc public func getDefaultSecurityConfiguration() -> SecurityConfiguration {
        guard let defaultConf = certRepo.getDefaultConfiguration() else {
            return SecurityConfiguration()
        }
        return SecurityConfiguration(host: defaultConf.host, trustPublicPKI: defaultConf.trustPublicPKI)
    }
    
    @objc public func setDefaultSecurityConfiguration(_ secConf: SecurityConfiguration) {
        let sc = certRepo.getSecurityConfiguration(secConf.host)
        certRepo.setDefaultConfiguration(sc)
    }
    
    @objc public func logout() {
        guard isInitialized else {
            return
        }
        
        // TODO ...
    }
}

class LoginCompleter: NSObject, FtauthinternalLoginCompleterProtocol {
    func complete(_ user: FtauthinternalUserData?, err: Error?) {
        if let err = err {
            completion?(nil, err)
            completion = nil
            return
        }
        guard let user = user else {
            completion?(nil, FTAuthError(errorCode: .authUnknown, details: "Empty user data"))
            completion = nil
            return
        }
        completion?(User(ID: user.id_), nil)
        completion = nil
    }
    
    private var completion: AuthenticationCompletionHandler?
    
    init(completion: AuthenticationCompletionHandler?) {
        self.completion = completion
    }
}
