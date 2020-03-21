//
//  Structs.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 A sample collection of data to use for development and debugging.
 */
public struct SampleData {
    
    // MARK: Properties
    var subreddit: Subreddit
    var redditor: Redditor
    var submission: Submission
    var inbox: Inbox
    var user: User
    
    // MARK: Initialization
    init() {
        
        // Construct values
        self.subreddit = Subreddit(fullName: "fullname", displayName: "Sample Subreddit", hotSubmissions: [])
        self.redditor = Redditor(username: "normal_redditor", karma: 0, friends: [])
        self.submission = Submission(authorName: redditor.username, creationDate: Date(), id: "0x0", parentSubreddit: subreddit, title: "Submission title", selftext: "Submission body content", urlValue: "https://www.google.com/", userScore: 1, totalScore: 10)
        self.inbox = Inbox(commentReplies: [], privateMessages: [])
        let subscriptions = [subreddit]
        let blockedRedditors = [String]()
        let front = [submission]
        
        // Assign values
        self.user = User(username: "sample_user", karma: 100, friends: [], subscriptions: subscriptions, blockedRedditors: blockedRedditors, front: front, inbox: inbox)
        
    }
    
}
