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
    
    // GET Endpoints
    
    /// Returns the identity of the user.
    // SRC: https://www.reddit.com/dev/api#GET_api_v1_me
    let me = "/api/v1/me"
    
    /// Returns a listing of friends of the user.
    // SRC: https://www.reddit.com/dev/api#GET_api_v1_me_friends
    let friends = "/api/v1/me/friends"
    
    /// Returns a listing of the subreddits the user is subscribed to
    // SRC: https://www.reddit.com/dev/api#GET_subreddits_mine_{where}
    let subscriptions = "/subreddits/mine/subscriber"
    
    /// Returns a list of the Redditors the user has blocked
    // SRC: https://www.reddit.com/dev/api#GET_prefs_{where}
    let blockedRedditors = "/prefs/blocked"
    
    /// Returns a list of the messages in a user's Inbox
    // SRC: https://www.reddit.com/dev/api#GET_message_inbox
    let inbox = "/message/inbox"
    
    /// Returns a list of the Submissions in the User's front page
    // SRC: https://www.reddit.com/dev/api#GET_best
    let front = "/best"
    
    /// Return a listing of things specified by their fullnames.
    // SRC: https://www.reddit.com/dev/api#GET_api_info
    let submissionLinkOrComment = "/api/info"
    
    // POST Endpoints
    
    /// Submit a reply to a comment, message, or submission.
    // SRC: https://www.reddit.com/dev/api#POST_api_comment
    let reply = "/api/comment"
    
    /// Cast a vote on a thing.
    // SRC: https://www.reddit.com/dev/api#POST_api_vote
    let vote = "/api/vote"
    
    /// Mark a message as read
    // SRC: https://www.reddit.com/dev/api#POST_api_read_message
    let readMessage = "/api/read_message"
    
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
