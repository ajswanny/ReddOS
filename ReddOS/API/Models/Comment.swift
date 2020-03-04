//
//  Comment.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 Implementation of a comment to a `Submission`.
 */
class Comment {
    
    var author: Redditor
    var body: String
    
    // Alphanumeric ID
    var id: String
    
    // The Submission this Comment belongs to
    var submission: Submission
    
    // The Subreddit this Comment's Submission belongs to
    var subreddit: Subreddit
    
    // Set of Comments that are replies to this Comment
    // More formal data structure needs to be defined in the future (somthing like PRAW's CommentForest)
    var replies: [Comment]?
 
    // Default init
    init(author: Redditor, body: String, id: String, submission: Submission, subreddit: Subreddit, replies: [Comment]?) {
        self.author = author
        self.body = body
        self.id = id
        self.submission = submission
        self.subreddit = subreddit
        self.replies = replies
    }
    
    func upvote() {}
    func downvote() {}
    
}
