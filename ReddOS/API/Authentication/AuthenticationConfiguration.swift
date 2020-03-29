//
//  AuthenticationConfiguration.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 Provides essential data to creeate an authenticated session for a logged-in user.
 */
public struct AuthenticationConfiguration {
    
    // MARK: Authentication Config
    /// Regular, default host
    public var regularHost = "www.reddit.com"
    
    /// Host to make requests after a user is authenticated
    public var oauthHost = "oauth.reddit.com"
    
    ///
    public var baseAuthorizationURL = "https://www.reddit.com/api/v1/authorize.compact?"
    
    ///
    public var state = "reddos-debugging"
    
    /// Temporary scope does not return a refresh token
    public var duration = "permanent"
    
    /// Initial authorization URL to retrieve code for access token
    public var authorizationURL: String {
        get {
            return "\(baseAuthorizationURL)client_id=\(clientId)&response_type=code&state=\(state)&redirect_uri=\(redirectUri)&duration=\(duration)&scope=\(scope)"
        }
    }
    
    /// Final authentication URL to retrieve an authorization token
    public var authenticationTokenURLValue = "https://www.reddit.com/api/v1/access_token"
    
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
