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

class Reddit {
    
    // MARK: Properties
    /// Host to make requests after a user is authenticated
    public var host = "oauth.reddit.com"
    
    /// Reference to the authentication controller
    var authenticationController: AuthenticationController
    
    /// The type for completion handlers of API request methods
    public typealias CompletionHandler = (Data?, Error?) -> Void    // TODO: Determine final type of first param
    
    // MARK: Initialization
    public init(authenticationController: AuthenticationController) {
        self.authenticationController = authenticationController
    }
    
    // MARK: Methods
    /**
     Vote on a submission or comment, providing the direction (-1: downvote, 0: unvote, 1: upvote).
     */
    public func vote(onRedditContent redditContent: RedditContent, inDirection direction: Int) {
        
    }
    
    /**
     Reply to a comment (comment on a comment), submission (comment on a submission) or a private message
     */
    public func reply(to target: Replyable, withContent content: String) {
        
    }
    
    /**
     Fetch new received Messages/Comment replies
     */
    public func refreshInbox() {
        
    }
    
    /**
     Mark a comment in the inbox as read to dismiss it
     */
    public func markAsRead(commentReply: Comment) {
        
    }
    
    /**
     Mark a private message as read to dismiss it
     */
    public func markAsRead(privateMessage: Message) {
        
    }
    
}
