//

//  Reddit.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/13/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 These prefixes are used when communicating with the Reddit API in order to identify a specific kind of Reddit ocject.
 */
public struct ObjectTypePrefixes {
    let comment = "t1_"
    let account = "t2_"
    let link = "t3_"
    let message = "t4_"
    let subreddit = "t5_"
    let award = "t6_"
}

public enum RedditError: Error {
    case userNotAuthenticated
    case authorizationExpired
    case networkConnectionLost
}

class Reddit {
    
    // MARK: Properties
    /// Host to make requests after a user is authenticated
    public var host = "https://oauth.reddit.com"
    
    /// Reference to the authentication controller
    var authenticationController: AuthenticationController
    
    /// The type for completion handlers of API request methods
    public typealias RequestFunctionCompletionHandler = (RequestExecutionResult?, Error?) -> Void    // TODO: Determine final type of first param
    public typealias RequestExecutionResult = [String: Any]
    public typealias RequestExecutionCompletionHandler = (RequestExecutionResult?, Error?) -> Void
    
    /// Authenticated user
    var user: User?
    
    // MARK: Initialization
    /**
     Default init
     */
    public init(authenticationController: AuthenticationController) {
        self.authenticationController = authenticationController
    }
    
    /**
     Validate a user authentication session
     */
    private func validateUserSession() throws {
        
        // Ensure user is authenticated
        if !authenticationController.userIsAuthenticated {
            throw RedditError.userNotAuthenticated
        }
        guard let userSession = authenticationController.userSession else {
            throw RedditError.userNotAuthenticated
        }
        
        // Ensure user session is within authentication time limit
        if !userSession.isWithinTimeLimit {
            throw RedditError.authorizationExpired
        }
        
    }
    
    // MARK: User
    /**
     Initializes all necessary user data.
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func initializeUserData(completionHandler: @escaping RequestFunctionCompletionHandler) throws {
        
        // Validate session
        try validateUserSession()
        
        // Fetch "me"
        let meEndpoint = APIEndpoint(base: .me)
        let meRequest = newUrlRequest(method: .get, endpoint: meEndpoint)
        
        // Execute and return unpacked data as as dict of Any ([String : Any])
        guard let request = meRequest else {
            throw RedditError.userNotAuthenticated
        }
        execute(request) { data, error in
            if let data = data {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, error)
            }
        }
        
    }
    
    // MARK: User Friends
    public func loadUserFriends(completionHandler: @escaping RequestFunctionCompletionHandler) throws {
        
        // Validate session
        try validateUserSession()
        
        // Fetch "friends"
        let friendsEndpoint = APIEndpoint(base: .friends)
        let friendsRequest = newUrlRequest(method: .get, endpoint: friendsEndpoint)
        
        // Execute and return unpacked data as as dict of Any ([String : Any])
        guard let request = friendsRequest else {
            throw RedditError.userNotAuthenticated
        }
        execute(request) { data, error in
            if let data = data {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, error)
            }
        }
        
    }
    
    // MARK: User Subscriptions
    public func loadUserSubscriptions(completionHandler: @escaping RequestFunctionCompletionHandler) throws {
        
        // Validate session
        try validateUserSession()
        
        // Fetch "subscriptions"
        let subscriptionsEndpoint = APIEndpoint(base: .subscriptions)
        let subscriptionsRequest = newUrlRequest(method: .get, endpoint: subscriptionsEndpoint)
        
        // Execute and return unpacked data as as dict of Any ([String : Any])
        guard let request = subscriptionsRequest else {
            throw RedditError.userNotAuthenticated
        }
        execute(request) { data, error in
            if let data = data {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, error)
            }
        }
        
    }
    
    // MARK: Blocked Redditors
    public func loadUserBlockedRedditors(completionHandler: @escaping RequestFunctionCompletionHandler) throws {
        
        // Validate session
        try validateUserSession()
        
        // Fetch "blocked"
        let blockedEndpoint = APIEndpoint(base: .blockedRedditors)
        let blockedRequest = newUrlRequest(method: .get, endpoint: blockedEndpoint)
        
    }
    
    // MARK: User Front
    public func loadUserFront(completionHandler: @escaping RequestFunctionCompletionHandler) throws {
        
        // Validate session
        try validateUserSession()
        
        // Fetch "front"
        let frontEndpoint = APIEndpoint(base: .front)
        let frontRequest = newUrlRequest(method: .get, endpoint: frontEndpoint)
        
        // Execute and return unpacked data as as dict of Any ([String : Any])
        guard let request = frontRequest else {
            throw RedditError.userNotAuthenticated
        }
        execute(request) { data, error in
            if let data = data {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, error)
            }
        }
        
    }
    
    // MARK: Vote
    /**
     Vote on a submission or comment, providing the direction (-1: downvote, 0: unvote, 1: upvote).
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func vote(onRedditContent redditContent: RedditContent, inDirection direction: Int, completionHandler: @escaping RequestFunctionCompletionHandler) {
        // TODO: Implement
        
    }
    
    // MARK: Reply
    /**
     Reply to a comment (comment on a comment), submission (comment on a submission) or a private message
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func reply(to target: Replyable, withContent content: String, completionHandler: @escaping RequestFunctionCompletionHandler) {
        // TODO: Implement
        
    }
    
    // MARK: Inbox
    /**
     Fetch new received Messages/Comment replies
     - Parameter completionHandler: The callback for when this request completes
     */
    public func refreshInbox(completionHandler: @escaping RequestFunctionCompletionHandler) {
        // TODO: Implement
        
    }
    
    // MARK: Mark as read
    /**
     Mark a comment in the inbox as read to dismiss it
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func markAsRead(commentReply: Comment, completionHandler: @escaping RequestFunctionCompletionHandler) {
        // TODO: Implement
        
    }
    
    /**
     Mark a private message as read to dismiss it
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func markAsRead(privateMessage: Message, completionHandler: @escaping RequestFunctionCompletionHandler) {
        // TODO: Implement
        
    }
    
    // MARK: Methods
    /**
     Creates a new HTTP request.
     - Parameters:
        - method:
        - endpoint:
     - Returns: The newly created URL request
     */
    public func newUrlRequest(method: HTTPRequestType, endpoint: APIEndpoint) -> URLRequest? {
        
        // Init the URL request
        let url = URL(string: endpoint.fullEndpoint)!
        var request = URLRequest(url: url)

        // Set request method and metadata
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("TEST", forHTTPHeaderField: "User-Agent")

        // Set authorization values
        guard let accessToken = authenticationController.activeSession?.accessToken else {
            return nil
        }
        let authorizationString = "bearer \(accessToken)"
        request.setValue(authorizationString, forHTTPHeaderField: "Authorization")

        return request
        
    }
      
    /**
     Executes a URL request for Reddit API, unpacks, and returns result to a provided completion  handler
     */
    public func execute(_ request: URLRequest, completion: @escaping RequestExecutionCompletionHandler) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(nil, error)
            }
            
            // Verify a desirable response was received and unwrap
            guard
                let _ = response as? HTTPURLResponse,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let package = json as? [String: Any]
            else {
                fatalError()
            }
            
            // Return data
            completion(package, nil)
            
        }
        task.resume()
        
    }
    
}
