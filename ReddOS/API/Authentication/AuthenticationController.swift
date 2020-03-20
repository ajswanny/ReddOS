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
enum AuthenticationTypes {
    case newUser
    case savedUser
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
    public init() {
        self.configuration = AuthenticationConfiguration()
    }
    
    /// Create a new authentication session for a new user
    private func authenticateNewUser(fromView presentationContextProvider: ASWebAuthenticationPresentationContextProviding) {
        
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
            
            // Fetch the access token to make API calls
            self.retrieveAccessToken(usingCode: code)
            
        }
        
        // Set the base view for the authentication safari view
        authorizationSession.presentationContextProvider = presentationContextProvider
        
        // Start the session
        authorizationSession.start()
        
    }
    
    /// Re-authenticate the current user
    private func reauthenticateCurrentUser() {
        // TODO: Implement
    }
    
    /// Initialize a read-only session
    private func authenticateGuestSession() {
        // TODO: Implement
    }
    
    /// Constructs a POST request in order to receive an access token that allows interaction with the Reddit API endpoints
    private func accessTokenRequest(usingCode code: String) -> URLRequest? {
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
        
        // The body of this post request
        var requestBody: Data? {
            
            // Necessary parameters to obtain a Reddit access token
            var parameters = [String: Any]()
            parameters["grant_type"] = "authorization_code"
            parameters["code"] = code
            parameters["redirect_uri"] = configuration.redirectUri
            let bodyParameters = parameters
            
            // Construct package from parameters
            var urlComponents = URLComponents()
            urlComponents.queryItems = bodyParameters.map({ (key, value) -> URLQueryItem in
                return URLQueryItem(name: key, value: "\(value)")
            })
            let bodyString = urlComponents.percentEncodedQuery
            
            return bodyString?.data(using: String.Encoding.utf8)
            
        }
        request.httpBody = requestBody
        
        // Set authorization values
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
        
        return request
        
    }
    
    /// Fetches the access token from Reddit using an already received authorization code
    private func retrieveAccessToken(usingCode code: String) {
        
        // TODO: Modify this section to allow for re-authentication
        // Construct the correct request from `code`
        guard let request = accessTokenRequest(usingCode: code) else {
            fatalError()
        }
        
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
                let scope = dictionary["scope"] as? String,
                let refreshToken = dictionary["refresh_token"] as? String
            else {
                fatalError()
            }
            
            // Store the received data
            self.userSession?.accessToken = accessToken
            self.userSession?.tokenType = tokenType
            self.userSession?.expirationDate = Date().addingTimeInterval(expiresIn)
            self.userSession?.scope = scope
            self.userSession?.refreshToken = refreshToken
            
        }
        task.resume()
        
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
