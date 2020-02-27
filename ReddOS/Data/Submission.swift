//
//  Submission.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 Implementation of a Reddit Submission.
 */
class Submission {
    
    var author: Redditor
    var title: String
    var creationDate: Date
    var body: String
    var link: String
    
    // Alphanumeric ID
    var id: String
    
    // The Subreddit this Submission was posted in
    var subreddit: Subreddit
    
    // More formal data structure needs to be defined in the future (somthing like PRAW's CommentForest)
    var comments: [Comment]?
    
    // Default init
    init(author: Redditor, creationDate: Date, id: String, subreddit: Subreddit, comments: [Comment]?, submissionContent: SubmissionContent) {
        self.author = author
        self.creationDate = creationDate
        self.id = id
        self.subreddit = subreddit
        self.comments = comments
        self.title = submissionContent.title
        self.body = submissionContent.body
        self.link = submissionContent.link
    }
    
    // Create a Comment for a Submission
    func reply() {}
    func upvote() {}
    func downvote() {}
    
}
