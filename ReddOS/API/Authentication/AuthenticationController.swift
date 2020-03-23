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

/// The different ways to authenticate
enum AuthenticationType {
    case newUser
    case existingUser
    case guestUser
}

/**
 Enables and controls Reddit authentication.
 Authentication can be performed for a new user, a previously logged-in user, or a guest session.
 */
class AuthenticationController {
    // TODO: Convert closures to methods for readability
    
    // MARK: Properties
    /// Access to essential data in order to successfully authenticate a user
    public var configuration: AuthenticationConfiguration
    
    /// The session to authenticate a new account
    public var webAuthSession: ASWebAuthenticationSession?
    
    /// TODO: Implement
    public var isAuthenticated: Bool {
        return self.userSession?.refreshToken != nil
    }
    
    /// OAuth authentication session for current user
    var userSession: AuthenticationSession?
    
    /// TODO: Implement creation. Should perhaps use a default Reddit account managed by us.
    var applicationSession: AuthenticationSession
    
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
    public init() {
        // TODO: Implement checking existing user session & pre-loading
        
        self.configuration = AuthenticationConfiguration()
        self.applicationSession = AuthenticationSession()   // TODO: Implement
        self.userSession = AuthenticationSession()
    }
    
    /**
     Create a new authentication session for a new user
     */
    private func authenticateNewUser(fromView presentationContextProvider: ASWebAuthenticationPresentationContextProviding) {
        
        // Initialize the new user session
        self.userSession = AuthenticationSession()
        
        // Validate the authorization URL
        guard let authorizationURL = URL(string: configuration.authorizationURL) else {
            return
        }
        
        // Create session object
        let authorizationSession = ASWebAuthenticationSession(url: authorizationURL, callbackURLScheme: configuration.callbackURLScheme)
        { callbackURL, error in
        /// The completion closure for completion of the authorization session
        /// TODO: Implement handling of a deny of access by the user
            
            // Validate the data sent through the callback
            guard
                error == nil,
                let callbackURL = callbackURL,
                let queryItems: [String: String] = callbackURL.queryParameters
            else {
                // TODO: Handle the error
                fatalError()
            }
            
            // Fetch the code to eaxchange for a bearer token
            guard let code = queryItems["code"] else {
                fatalError()
            }
            
            // Create the access token POST request for a new user session
            guard let newUserAccessTokenRequest = self.newUserAccessTokenRequest(usingAuthorizationCode: code) else {
                fatalError()
            }
            
            // Fetch the access token to make API calls
            self.retrieveAccessToken(for: .newUser, usingRequest: newUserAccessTokenRequest)
            
        }
        
        // Set the base view for the authentication safari view and start the auth session
        authorizationSession.presentationContextProvider = presentationContextProvider
        authorizationSession.start()
        
    }
    
    /**
     Re-authenticate the current user
     */
    private func reauthenticateCurrentUser() {
        // TODO: Implement
    }
    
    /**
     Initialize a read-only session
     */
    private func authenticateGuestSession() {
        // TODO: Implement
    }
    
    /**
     Fetches the access token from Reddit for a user session using an already received authorization code
     - Parameters:
        - authticationType: A new or existing user
        - code: The code returned by the authorization request
     */
    private func retrieveAccessToken(for authenticationType: AuthenticationType, usingRequest request: URLRequest) {
        
        // Set up and execute the necessary POST request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Verify a desirable response was received
            guard let data = data, let _ = response as? HTTPURLResponse, error == nil else {
                fatalError()
            }
            
            // Validate received data
            guard
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let dictionary = json as? [String: Any],
                let accessToken = dictionary["access_token"] as? String,
                let tokenType = dictionary["token_type"] as? String,
                let expiresIn = dictionary["expires_in"] as? Double,
                let scope = dictionary["scope"] as? String
            else {
                fatalError()
            }
            
            // Ensure self.userSession has been initialized
            guard let userSession = self.userSession else {
                fatalError()
            }
            
            // Store the received data necessary for both .newUser and .existingUser
            userSession.accessToken = accessToken
            userSession.tokenType = tokenType
            userSession.expirationDate = Date().addingTimeInterval(expiresIn)
            userSession.scope = scope
            
            // If this is authenticationg a new user, record the newly received refresh token
            if authenticationType == .newUser {
                
                // Read the refresh token for a new user
                guard let refreshToken = dictionary["refresh_token"] as? String else {
                    fatalError()
                }
                userSession.refreshToken = refreshToken
                
            }
            
        }
        task.resume()
        
    }
    
    /**
     Constructs a POST request in order to receive an access token for a new user that allows interaction with the Reddit API endpoints. Authenticating a new user and re-authenticating an existing user both require different body parameters (see [Retrieving the access token]( https://github.com/reddit-archive/reddit/wiki/oauth2#retrieving-the-access-token)).
     */
    private func newUserAccessTokenRequest(usingAuthorizationCode authorizationCode: String) -> URLRequest? {
        // TODO: Simplify
        
        // Init request object
        guard let authenticationTokenURL = URL(string: configuration.authenticationTokenURLValue) else {
            return nil
        }
        var request = URLRequest(url: authenticationTokenURL)
        
        // Set method
        request.httpMethod = "POST"
        
        // Set values for POST headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Set authorization values (same for .newUser and .existingUser)
        var authorizationValue: String {
            let loginString = "\(configuration.clientId):"
            let loginData = loginString.data(using: String.Encoding.utf8)
            if let loginBase64 = loginData?.base64EncodedString(options: []) {
                return "Basic \(loginBase64)"
            } else {
                return "Basic"
            }
        }
        request.setValue(authorizationValue, forHTTPHeaderField: "Authorization")
        // TODO: All above can be generalized for .newUser and .existingUser
        
        // The body of this post request
        var requestBody: Data? {
            
            // Necessary parameters to obtain a Reddit access & refresh token
            var parameters = [String: Any]()
            parameters["grant_type"] = "authorization_code"
            parameters["code"] = authorizationCode
            parameters["redirect_uri"] = configuration.redirectUri
            
            // Construct package from parameters
            var urlComponents = URLComponents()
            urlComponents.queryItems = parameters.map({ (key, value) -> URLQueryItem in
                return URLQueryItem(name: key, value: "\(value)")
            })
            let bodyString = urlComponents.percentEncodedQuery
            
            return bodyString?.data(using: String.Encoding.utf8)
            
        }
        request.httpBody = requestBody
        
        return request
        
    }
    
    /**
     Constructs a POST request in order to receive an access token for an existing user. Authenticating a new user and re-authenticating an existing user both require different body parameters (see [Refreshing the token]( https://github.com/reddit-archive/reddit/wiki/oauth2#refreshing-the-token)).
     */
    private func existingUserAccessTokenRequest() {
        
        
    }
    
    // MARK: Helper Methods
    /**
     Retrieves the specified value from a URL's query items
     */
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
