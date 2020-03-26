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
class User {
    
    // MARK: Properties
    
    /// The username
    var username: String?
    
    /// The total karma of this Redditor
    var karma: Int?
    
    /// A list of friends
    var friends: [String]?
    
    /// The link to this Redditor's URL. This value will be dynamically loaded
    var profilePictureUrl: String? {
        didSet {
            // Implement instantiation of profilePicture here
        }
    }
    
    /// Actual profile picture data that can be converted to a UIImage
    var profilePicture: Data?

    /// List of subreddits the user is a subscriber of
    var subscriptions: [Subreddit]?
    
    /// List of redditors' names this user has blocked
    var blockedRedditors: [String]?
    
    /// Reference to the user's Inbox instance
    var inbox: Inbox?
    
    /// The front page (the 'BEST' Submissions)
    var front: [Submission]?
    
    // MARK: Initialization
    /**
     Default init
     */
    init() {
    }
    
    /**
     
     */
    init(username: String, karma: Int, friends: [String], subscriptions: [Subreddit], blockedRedditors: [String], front: [Submission], inbox: Inbox) {
        self.subscriptions = subscriptions
        self.blockedRedditors = blockedRedditors
        self.front = front
        self.inbox = inbox
        self.friends = friends
    }
    
}
