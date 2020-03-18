//
//  AuthenticationController.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/13/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation
import AuthenticationServices

/**
 Provides essential data to creeate an authenticated session for a logged-in user.
 */
public struct AuthenticationConfiguration {
    
    // MARK: API
    /// Regular, default host
    public var regularHost = "www.reddit.com"
    
    /// Host to make requests after a user is authenticated
    public var oauthHost = "oauth.reddit.com"
    
    ///
    public var baseAuthorizationURL = "https://www.reddit.com/api/v1/authorize.compact?"
    
    ///
    public var state = "reddos-debugging"
    
    ///
    public var duration = "temporary"
    
    /// Initial authentication URL (temporary valuesa at the moment)
    public var authorizationURL: String {
        let url = "\(baseAuthorizationURL)client_id=\(clientId)&response_type=code&state=\(state)&redirect_uri=\(redirectUri)&duration=\(duration)&scope=\(scope)"
        return "https://www.reddit.com/api/v1/authorize.compact?client_id=XIt7mz1GlhOx1w&response_type=code&state=test_state&redirect_uri=reddos://https://github.com/ajswanny/ReddOS&duration=temporary&scope=identity,edit"
    }
    
    /// Final authentication URL to retrieve an authorization token
    public var authenticationTokenURL = "https://www.reddit.com/api/v1/access_token"
    
    /// Identifier for URL for succesful authorization
    public var callbackURLScheme = "reddos"
    
    /// Version of the client
    public var clientVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    
    // MARK: Authentication Data
    /// ID of the app making requests
    public var clientId = "XIt7mz1GlhOx1w"
    
    /// The redirect URI set during authentication
    public var redirectUri = "reddos://https://github.com/ajswanny/ReddOS"
    
    /// The permissions to request when authenticating
    public var scope: String = "identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote"
    
    /// Unique identifier for a unique request
    /// To init: self.authorizationState = UUID().uuidString
    private var authorizationState: String?
    
    // MARK: Initialization
    public init(scope: String? = nil) {
        if let scope = scope {
            self.scope = scope
        }
    }
    
}

/// The different ways to authenticate
enum AuthenticationTypes {
    case newUser
    case savedUser
    case guestUser
}


/**
 Manages all authentication the currently logged-in user.
 Reddit OAuth-authentication details can be found at: https://github.com/reddit-archive/reddit/wiki/oauth2
 */
class AuthenticationController: NSObject {
    
    // MARK: Properties
    /// Access to essential data in order to successfully authenticate a user
    public var configuration: AuthenticationConfiguration
    
    /// The session to authenticate a new account
    public var webAuthSession: ASWebAuthenticationSession?
    
    /// The view from which to bring up the authentication view
    public var presentationContextProvider: ASWebAuthenticationPresentationContextProviding?
    
    /// TODO: Implement
    public var isAuthenticated: Bool {
        return self.userSession?.refreshToken != nil
    }
    
    /// OAuth authentication session for current user
    var userSession: AuthenticationSession?
    
    /// Public access to self.userSession
    public var activeUserSession: AuthenticationSession? {
        return self.userSession
    }
    
    /// TODO: Implement creation. Should perhaps use a default Reddit account managed by us.
    var applicationSession: AuthenticationSession?
    
    /// The active session: logged in or not
    var activeSession: AuthenticationSession? {
        get {
            if self.userSession != nil {
                return self.userSession
            } else {
                // This will determine whether or not to load default data for the front page
                return self.applicationSession
            }
        }
    }
    
    // MARK: Initialization
    override init() {
        self.configuration = AuthenticationConfiguration()
        super.init()
    }
    
    // MARK: Authentication Methods
    /// The main method to use in view controllers
    /// Validates authentication and performs it if it all data is provided correctly
    public func attemptAuthentication(fromView: ASWebAuthenticationPresentationContextProviding, for userType: AuthenticationTypes = .guestUser) {
        // Check if this is a new-authentication or re-authentication
        switch userType {
            case .newUser:
                authenticate()
            case .savedUser:
                reauthenticate()
            case .guestUser:
                initGuestSession()
        }
        
    }
    
    /// Create a new authentication session
    /// TODO: Initialize `applicationSession` or `userSession`
    private func authenticate() {
        
        // Validate the authentication URL
        guard let authURL = URL(string: configuration.authorizationURL) else {
            return
        }
        
        // Create session object
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: configuration.callbackURLScheme)
        { callbackURL, error in
            
            // Validate the data sent through the callback
            guard
                error == nil,
                let callbackURL = callbackURL,
                let queryItems: [String: String] = callbackURL.queryParameters
            else {
                // TODO: Handle the error
                return
            }
            
            // Fetch the code to eaxchange for a bearer token
            let code = queryItems["code"]!
            
            // Perform POST request with `code` to get the authorization token
            
            
            // Check for successful reception of the code for the retrieval of a bearer token
            print(queryItems)
            
        }
        
        /// Set the base view for the authentication safari view (was validated in `attemptAuthentication(fromView:)`
        session.presentationContextProvider = self.presentationContextProvider!
        
        // Start the session
        session.start()
        
    }
    
    /// Re-authenticate the current user
    /// TODO: Implement
    private func reauthenticate() {
        
    }
    
    /// Initialize a read-only session
    /// TODO: Implement
    private func initGuestSession() {
        
    }
    
    // MARK: Helper Methods
    // Retrieves the specified value from a URL's query items
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
}


// MARK: Extensions
extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
