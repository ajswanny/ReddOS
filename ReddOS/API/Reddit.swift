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

public enum RequestError: Error {
    case userNotAuthenticated
    case authorizationExpired
    case networkConnectionLost
}

class Reddit {
    
    // MARK: Properties
    /// Host to make requests after a user is authenticated
    public var host = "oauth.reddit.com"
    
    /// Reference to the authentication controller
    var authenticationController: AuthenticationController
    
    /// The type for completion handlers of API request methods
    public typealias RequestCompletionHandler = (Data?, Error?) -> Void    // TODO: Determine final type of first param
    
    // MARK: Initialization
    /**
     Default init
     */
    public init(authenticationController: AuthenticationController) {
        self.authenticationController = authenticationController
    }
    
    // MARK: Methods
    /**
     Initializes all necessary user data.
     Calls the API endpoints: me, friends, subscriptions, blocked, inbox, front.
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func initializeUserData(completionHandler: @escaping RequestCompletionHandler) throws {
        
        if !authenticationController.isAuthenticated {
            throw RequestError.userNotAuthenticated
        } else {
            // Fetch "me"
            let meEndpoint = APIEndpoint(base: .me)
            let meRequest = newUrlRequest(method: .get, endpoint: meEndpoint)
//            if Date() >= authenticationController.activeSession?.expirationDate {
//
//            }
        }
        
        
    }
    
    /**
     Vote on a submission or comment, providing the direction (-1: downvote, 0: unvote, 1: upvote).
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func vote(onRedditContent redditContent: RedditContent, inDirection direction: Int, completionHandler: @escaping RequestCompletionHandler) {
        // TODO: Implement
        
    }
    
    /**
     Reply to a comment (comment on a comment), submission (comment on a submission) or a private message
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func reply(to target: Replyable, withContent content: String, completionHandler: @escaping RequestCompletionHandler) {
        // TODO: Implement
        
    }
    
    /**
     Fetch new received Messages/Comment replies
     - Parameter completionHandler: The callback for when this request completes
     */
    public func refreshInbox(completionHandler: @escaping RequestCompletionHandler) {
        // TODO: Implement
        
    }
    
    /**
     Mark a comment in the inbox as read to dismiss it
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func markAsRead(commentReply: Comment, completionHandler: @escaping RequestCompletionHandler) {
        // TODO: Implement
        
    }
    
    /**
     Mark a private message as read to dismiss it
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func markAsRead(privateMessage: Message, completionHandler: @escaping RequestCompletionHandler) {
        // TODO: Implement
        
    }
    
    /**
     Creates a new HTTP request.
     - Parameters:
        - method:
        - endpoint:
     - Returns: The newly created URL request
     */
    public func newUrlRequest(method: HTTPRequestType, endpoint: APIEndpoint) -> URLRequest? {
        
        // Init the URL request
        guard let url = URL(string: endpoint.fullEndpoint) else {
            return nil
        }
        var request = URLRequest(url: url)
        
        // Set request method and metadata
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Set authorization values
        guard let accessToken = authenticationController.activeSession?.accessToken else {
            return nil
        }
        let authorizationString = "bearer \(accessToken)"
        request.setValue(authorizationString, forHTTPHeaderField: "Authorization")
        
        return request
        
    }
    
    public func execute(request: URLRequest, completion: @escaping RequestCompletionHandler) {
        // TODO: Implement
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Verify a desirable response was received
            guard let data = data, let _ = response as? HTTPURLResponse, error == nil else {
                fatalError()
            }
            
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
//                print(<#T##items: Any...##Any#>)
//            }
            
        }
        
    }
    
}
