//
//  User.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 `User` is the main, authenticated user for the application.
 */
class User: Redditor {
    
    var subredditsSubscribedTo: [Subreddit]
    var blockedRedditors: [Redditor]
    var upvotedSubmissions: [Submission]
    var downvotedSubmissions: [Submission]
    var inbox: Inbox
    
    // The front page of a Redditor (the Hot Submissions)
    var front: [Submission]
    
    // Default init
    init(username: String, karma: Int, friends: [Redditor], userContent: UserContent) {
        self.subredditsSubscribedTo = userContent.subredditsSubscribedTo
        self.blockedRedditors = userContent.blockedRedditors
        self.upvotedSubmissions = userContent.upvotedSubmissions
        self.downvotedSubmissions = userContent.downvotedSubmissions
        self.front = userContent.front
        self.inbox = userContent.inbox
        super.init(username: username, karma: karma, friends: friends)
    }
    
}
