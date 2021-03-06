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
    
    /// Whether or not the user session is authorized for authentication
    public var userIsAuthorizedForAuthentication: Bool {
        return userSession?.refreshToken != nil
    }
    
    /// OAuth authentication session for current user
    var userSession: AuthenticationSession? {
        didSet {
            if userSession?.refreshToken != nil {
                #if DEBUG
                print("New value set for AuthenticationController.userSession; saving the object...")
                #endif
                saveUserSession()
            }
        }
    }
    
    var previousUserSession: AuthenticationSession?
    
    /// The URL for the file containing the serialization of the user session object
    var userSessionDataStore: URL {
        return self.getDirectoryPath().appendingPathComponent("userSession.ser")
    }
    
    /// TODO: Implement creation
    var guestSession: AuthenticationSession
    
    /// The active session: logged in or not
    var activeSession: AuthenticationSession? {
        get {
            if self.userSession != nil {
                return self.userSession
            } else {
                // This will determine whether or not to load default data for the front page
                return self.guestSession
            }
        }
    }
    
    /// The base for an access token request for a Reddit user account
    var baseAccessTokenRequest: URLRequest {
        
        // Init values
        guard let authenticationTokenURL = URL(string: configuration.authenticationTokenURLValue) else { fatalError() }
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
        
        return request
        
    }
    
    // MARK: Initialization
    /**
     Default init
     */
    public init() {
        
        // Init config
        self.configuration = AuthenticationConfiguration()
        
        // TODO: Implement correct implementation
        self.guestSession = AuthenticationSession()
        
        // Check for previous user session
        if let decodedUserSessionData = UserDefaults.standard.data(forKey: "userSession"),
           let object = try? JSONDecoder().decode(AuthenticationSession.self, from: decodedUserSessionData) {
            // Store the object
            self.previousUserSession = object
            
            // Reauthenticate
            reauthenticateCurrentUser()
            #if DEBUG
            print("Successfully reauthenticated")
            #endif
            
        } else {
            // Create new session object
            self.previousUserSession = AuthenticationSession()
            #if DEBUG
            print("User session is not authorized for authentication; foregoing re-authentication.")
            #endif
        }
        
    }
    
    /**
     Logs out the current user
     */
    public func logoutUserSession() {
        userSession?.logout()
        UserDefaults.standard.removeObject(forKey: "userSession")
    }
    
    // MARK: New User Authentication
    /**
     Create a new authentication session for a new user
     */
    public func authenticateNewUser(fromView presentationContextProvider: AccountViewController) {
        
        // Validate the authorization URL
        guard let authorizationURL = URL(string: configuration.authorizationURL) else { fatalError() }
        
        // Create session object
        let authorizationSession = ASWebAuthenticationSession(url: authorizationURL, callbackURLScheme: configuration.callbackURLScheme)
        { callbackURL, error in
        /// The completion closure for completion of the authorization session
            
            // Validate the data sent through the callback
            guard
                error == nil,
                let callbackURL = callbackURL,
                let queryItems: [String: String] = callbackURL.queryParameters
            else {
                let alert = UIAlertController(title: "Login Failed", message: "Login canceled or failed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                presentationContextProvider.present(alert, animated: true, completion: nil)
                return
            }
            
            // Fetch the code to eaxchange for a bearer token
            guard let code = queryItems["code"] else { fatalError() }
            
            // Create the access token POST request for a new user session
            guard let newUserAccessTokenRequest = self.newUserAccessTokenRequest(usingAuthorizationCode: code) else { fatalError() }
            
            // Fetch the access token to make API calls
            self.retrieveAndStoreAccessToken(for: .newUser, usingRequest: newUserAccessTokenRequest)
            
        }
        
        // Set the base view for the authentication safari view and start the auth session
        authorizationSession.presentationContextProvider = presentationContextProvider
        authorizationSession.start()
        
    }
    
    // MARK: User Re-Authentication
    /**
     Re-authenticate the current user
     */
    private func reauthenticateCurrentUser() {
        
        // Create the access token POST request for a new user session
        guard let existingUserAccessTokenRequest = existingUserAccessTokenRequest() else { fatalError() }
        
        // Execute the request
        retrieveAndStoreAccessToken(for: .existingUser, usingRequest: existingUserAccessTokenRequest)
        
    }
    
    // MARK: Guest User Authentication
    /**
     Initialize a read-only session
     */
    private func authenticateGuestSession() {
        // TODO: Implement
    }
    
    // MARK: Token URL Request Creation
    /**
     Constructs a POST request in order to receive an access token for a new user that allows interaction with the Reddit API endpoints. Authenticating a new user and re-authenticating an existing user both require different body parameters (see [Retrieving the access token]( https://github.com/reddit-archive/reddit/wiki/oauth2#retrieving-the-access-token)).
     */
    private func newUserAccessTokenRequest(usingAuthorizationCode authorizationCode: String) -> URLRequest? {
        
        // Initialize the request object
        var request = baseAccessTokenRequest
        
        // Define and set the body
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
    private func existingUserAccessTokenRequest() -> URLRequest? {
        
        // Initialize the request object
        var request = baseAccessTokenRequest
        
        // Define and set the body
        guard let refreshToken = previousUserSession?.refreshToken else { fatalError() }
        var requestBody: Data? {
            
            // Necessary parameters to obtain a Reddit access & refresh token
            var parameters = [String: Any]()
            parameters["grant_type"] = "refresh_token"
            parameters["refresh_token"] = refreshToken
            
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
    
    // MARK: Token Retrieval
    /**
     Fetches the access token from Reddit for a user session using an already received authorization code
     - Parameters:
        - authticationType: A new or existing user
        - code: The code returned by the authorization request
     */
    private func retrieveAndStoreAccessToken(for authenticationType: UserAuthenticationType, usingRequest request: URLRequest) {
        
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
                let _ = dictionary["scope"] as? String
            else {
                fatalError()
            }
            
            // Store the received data necessary for both .newUser and .existingUser
            let newAuthenticationSession = AuthenticationSession()
            newAuthenticationSession.accessToken = accessToken
            newAuthenticationSession.tokenType = tokenType
            newAuthenticationSession.expirationDate = Date().addingTimeInterval(expiresIn)
            
            // If this is authenticationg a new user, record the newly received refresh token
            if authenticationType == .newUser {
                // Read the refresh token for a new user
                guard let refreshToken = dictionary["refresh_token"] as? String else {
                    fatalError()
                }
                newAuthenticationSession.refreshToken = refreshToken
            
            // Reset the refresh token from the copy of the previous user session
            } else {
                newAuthenticationSession.refreshToken = self.previousUserSession?.refreshToken
            }
            
            #if DEBUG
            print("Successfully stored the access token for: \(authenticationType.rawValue).")
            print("Authenticated with access token: \(newAuthenticationSession.accessToken ?? "")")
            #endif
            
            // Set current user session to newUserSession
            self.userSession = newAuthenticationSession
            
            // Notify App
            NotificationCenter.default.post(name: .onAuthenticated, object: nil)
            
        }
        task.resume()
        
    }

    // MARK: Serialization
    /**
     Stores the user session for future use
     */
    private func saveUserSession() {
        
        // Store user session
        guard let encoded = try? JSONEncoder().encode(self.userSession) else {
            fatalError()
        }
        UserDefaults.standard.set(encoded, forKey: "userSession")
        
    }
    
    /**
     Reloads the stored user session
     */
    private func loadUserSession() -> AuthenticationSession {
        
        do {
            let data = try Data(contentsOf: userSessionDataStore)
            guard let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AuthenticationSession else { fatalError() }
            #if DEBUG
            if let refreshToken = object.refreshToken {
                print("Successfully de-serialized authorized user session with refresh token: \(refreshToken).")
            } else {
                print("Successfully de-serialized unauthorized user session.")
            }
            #endif
            return object
        } catch {
            fatalError()
        }
        
    }
    
    /**
     
     */
    private func getDirectoryPath() -> URL {
        let arrayPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return arrayPaths[0]
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
