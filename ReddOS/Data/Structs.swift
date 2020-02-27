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

public struct SubmissionContent {
    var title: String
    var body: String
    var link: String
}
