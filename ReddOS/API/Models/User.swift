//
//  User.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 A helper struct to make `User` initialization cleaner. This contains all the data a User will interact with.
 */

/**
 `User` is the main, authenticated user for the application.
 */
class User: Redditor {
    
    // MARK: Properties
    /// Refrence to the app's reddit instance
    var reddit: Reddit?
    
    /// List of subreddits the user is a subscriber of
    var subscriptions: [Subreddit]
    
    /// List of redditors' names this user has blocked
    var blockedRedditors: [String]
    
    /// Reference to the user's Inbox instance
    var inbox: Inbox
    
    /// The front page (the 'BEST' Submissions)
    var front: [Submission]
    
    // MARK: Initialization
    /**
     Default init
     */
    init(reddit: Reddit, username: String, karma: Int, friends: [Redditor], subscriptions: [Subreddit], blockedRedditors: [String], front: [Submission], inbox: Inbox) {
        self.reddit = reddit
        self.subscriptions = subscriptions
        self.blockedRedditors = blockedRedditors
        self.front = front
        self.inbox = inbox
        super.init(username: username, karma: karma, friends: friends)
    }
    
    init(username: String, karma: Int, friends: [Redditor], subscriptions: [Subreddit], blockedRedditors: [String], front: [Submission], inbox: Inbox) {
        self.subscriptions = subscriptions
        self.blockedRedditors = blockedRedditors
        self.front = front
        self.inbox = inbox
        super.init(username: username, karma: karma, friends: friends)
    }
    
}
