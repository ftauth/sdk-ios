import FTAuthInternal

public enum FTAuthError: Error {
    case initializationError(_ details: String = "An unknown error occurred")
    case unsupportedPlatform
    case uninitialized
    case unknown (_ details: String = "An unknown error occurred")
}

public class FTAuthClient: NSObject {
    @objc public static let shared = FTAuthClient()
    private var internalClient: FtauthinternalClient?
    private let keystore = FTAuthKeyStore()
    
    public var isInitialized: Bool {
        internalClient != nil
    }
    
    @objc public func initialize(withJSON configJSON: Data) throws {
        try keystore.clear()
        
        var optionsErr: NSError?
        let options = FtauthinternalNewClientOptions(30, true, keystore, FTAuthLogger(), configJSON, &optionsErr)
        if let optionsErr = optionsErr {
            throw FTAuthError.initializationError(optionsErr.localizedDescription)
        }
        
        var clientErr: NSError?
        let client = FtauthinternalNewClient(options, &clientErr)
        if let clientErr = clientErr {
            throw FTAuthError.initializationError(clientErr.localizedDescription)
        }
        guard let internalClient = client else {
            throw FTAuthError.initializationError()
        }
        
        self.internalClient = internalClient
    }
    
    @objc public func initialize(withURL url: URL) throws {
        let configJSON = try Data(contentsOf: url)
        return try initialize(withJSON: configJSON)
    }
    
    @objc public func initialize() throws {
        guard let url = Bundle.main.url(forResource: "ftauth_config.json", withExtension: nil) else {
            throw FTAuthError.initializationError("Could not find configuration file: ftauth_config.json")
        }
        return try initialize(withURL: url)
    }
    
    @objc public func login(completion: AuthenticationCompletionHandler? = nil) {
        guard let internalClient = internalClient else {
            completion?(nil, FTAuthError.uninitialized)
            return
        }
        
        if #available(iOS 12.0, macOS 10.15, macCatalyst 13.0, watchOS 6.2, *) {
            DispatchQueue.global(qos: .userInitiated).async {
                internalClient.login(AuthenticationSession(), completion: LoginCompletion(completion: completion))
            }
            return
        }
        
        #if !os(watchOS)
        if #available(iOS 11.0, *) {
            DispatchQueue.global(qos: .userInitiated).async {
                internalClient.login(AuthenticationSessionCompat(), completion: LoginCompletion(completion: completion))
            }
            return
        }
        #endif
            
        completion?(nil, FTAuthError.unsupportedPlatform)
    }
    
    @objc public func logout() {
        guard isInitialized else {
            return
        }
        
        // TODO ...
    }
}

class LoginCompletion: NSObject, FtauthinternalLoginCompleterProtocol {
    func complete(_ user: FtauthinternalUserData?, err: Error?) {
        guard let user = user else {
            completion?(nil, FTAuthError.unknown("Empty user data"))
            return
        }
        completion?(User(ID: user.id_), err)
    }
    
    private var completion: AuthenticationCompletionHandler?
    
    init(completion: AuthenticationCompletionHandler?) {
        self.completion = completion
    }
}
