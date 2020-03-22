//
//  Endpoints.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/22/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

// MARK: API Endpoints
public enum APIEndpointBase: String {
    
    // GET Endpoints
    
    /**
     Returns the identity of the user.
     SRC: https://www.reddit.com/dev/api#GET_api_v1_me
     */
    case me = "/api/v1/me"
    
    /**
     Returns a listing of friends of the user.
     SRC: https://www.reddit.com/dev/api#GET_api_v1_me_friends
     */
    case friends = "/api/v1/me/friends"
    
    /**
     Returns a listing of the subreddits the user is subscribed to
     SRC: https://www.reddit.com/dev/api#GET_subreddits_mine_{where}
     */
    case subscriptions = "/subreddits/mine/subscriber"
    
    /**
     Returns a list of the Redditors the user has blocked
     SRC: https://www.reddit.com/dev/api#GET_prefs_{where}
     */
    case blockedRedditors = "/prefs/blocked"
    
    /**
     Returns a list of the messages in a user's Inbox
     SRC: https://www.reddit.com/dev/api#GET_message_inbox
     */
    case inbox = "/message/inbox"
    
    /**
     Returns a list of the Submissions in the User's front page
     SRC: https://www.reddit.com/dev/api#GET_best
     */
    case front = "/best"
    
    /**
     Return a listing of things specified by their fullnames.
     SRC: https://www.reddit.com/dev/api#GET_api_info
     */
    case submissionLinkOrComment = "/api/info"
    
    // POST Endpoints
    
    /**
     Submit a reply to a comment, message, or submission.
     Params:
        - parent: the fullname of the thing being replied to
        - text:     should be the raw markdown body of the comment or message
     SRC: https://www.reddit.com/dev/api#POST_api_comment
     */
    case reply = "/api/comment"
    
    /**
     Cast a vote on a thing.
     Params:
        - id:   should be the fullname of the Link (Submission) or Comment to vote on.
        - dir:  indicates the direction of the vote. Voting 1 is an upvote, -1 is a downvote, and 0 is
        equivalent to "un-voting" by clicking again on a highlighted arrow
     SRC: https://www.reddit.com/dev/api#POST_api_vote
     */
    case vote = "/api/vote"
    
    /**
     Mark a message as read
     Params:
     - id: a comma-separated list of thing fullnames
     SRC: https://www.reddit.com/dev/api#POST_api_read_message
     */
    case readMessage = "/api/read_message"
    
}

/**
 
 */
public enum RequestType: String {
    
    ///
    case get = "GET"
    
    ///
    case post = "POST"
    
}

/**
 Implements creation of a full API endpoint, allowing for the easy incorporation of query parameters.
 */
public class APIEndpoint {
    
    // MARK: Properties
    /// Host for endpoints
    var host = "oauth.reddit.com"
    
    /// The base for this endpoint
    var baseEndpoint: APIEndpointBase
    
    /// Constructs the full endpoint with given params
    var fullEndpoint: String? {
        
        // The list of query items to be constructed from self.params
        var queryItems = [NSURLQueryItem]()
        for param in parameters {
            queryItems.append(NSURLQueryItem(name: param.key, value: param.value))
        }
        
        // Construct and return full url as string
        let urlComponents = NSURLComponents(string: "\(host)\(baseEndpoint)")
        return urlComponents?.url?.absoluteString
        
    }
    
    /// The list of parameters to be included as query parameters in the final URL
    var parameters: [String: String]
    
    // MARK: Initialization
    /**
     Default init
     */
    init(base: APIEndpointBase, parameters: [String: Any]) {
        self.baseEndpoint = base
        
        // Check that parameter values are of type String or Int
        self.parameters = [String: String]()
        for param in parameters {
            if let val = param.value as? Int {
                let val_string = "\(val)"
                self.parameters[param.key] = val_string
            } else if let val = param.value as? String {
                self.parameters[param.key] = val
            } else {
                fatalError()
            }
        }
        
    }
    
}
