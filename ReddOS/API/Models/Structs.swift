//
//  Structs.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 A helper struct to make `User` initialization cleaner. This contains all the data a User will interact with.
 */
public struct UserContent {
    var subredditsSubscribedTo: [Subreddit]
    var blockedRedditors: [Redditor]
    var upvotedSubmissions: [Submission]
    var downvotedSubmissions: [Submission]
    var inbox: Inbox
    var front: [Submission]
}

public struct SampleData {
    
    var subreddit: Subreddit
    var redditor: Redditor
    var submission: Submission
    var inbox: Inbox
    var user: User
    
    init() {
        self.subreddit = Subreddit(fullName: "fullname", displayName: "Sample Subreddit", hotSubmissions: [])
        self.redditor = Redditor(username: "normal_redditor", karma: 0, friends: [])
        self.submission = Submission(author: redditor, creationDate: Date(), id: "0x0", subreddit: subreddit, comments: [], title: "Submission title", selftext: "Submission body content", url: "https://www.google.com/")
        self.inbox = Inbox(commentReplies: [], privateMessages: [])
        let userContent = UserContent(subredditsSubscribedTo: [subreddit], blockedRedditors: [], upvotedSubmissions: [submission], downvotedSubmissions: [], inbox: inbox, front: [submission])
        self.user = User(username: "sample_user", karma: 100, friends: [], userContent: userContent)
    }
    
}
