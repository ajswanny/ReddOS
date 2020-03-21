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

// MARK: API Endpoints
public struct APIEndpoints {
    
    /// Returns the identity of the user.
    let me = "/api/v1/me"
    
    /// Returns a listing of friends of the user.
    let friends = "/api/v1/me/friends"
    
    /// Returns a listing of the subreddits the user is subscribed to
    let subscriptions = "/subreddits/mine/subscriber"
    
}

class Reddit {
    
    // MARK: Properties
    /// Host to make requests after a user is authenticated
    public var host = "oauth.reddit.com/"
    
    /// Reference to the authentication controller
    var authenticationController: AuthenticationController
    
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
     Send a message from current user to a recipient given the recipient's username.
     */
    public func sendMessage(to recipientName: String, withContent content: String) {
        
    }
    
    /**
     Reply to a comment (comment on a comment) or submission (comment on a submission)
     */
    public func reply(to target: RedditContent, withContent content: String) {
        // TODO: Implement check for sending too many requests
    }
    
    /**
     Reply to a message in the inbox
     */
    public func reply(toMessage message: Message, withContent content: String) {
        
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
