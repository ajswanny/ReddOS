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
    
    // The title of the submission.
    var title: String
    
    // Time the submission was created
    var creationDate: Date
    
    // The submissions’ selftext - an empty string if a link post.
    var selftext: String
    
    // The URL the submission links to, or the permalink if a selfpost.
    var url: URL?
    var urlValue: String {
        didSet {
            // Implement detection and loading of URL (image of link)
        }
    }
    
    // Alphanumeric ID
    var id: String
    
    // The Subreddit this Submission was posted in
    var subreddit: Subreddit
    
    // More formal data structure needs to be defined in the future (somthing like PRAW's CommentForest)
    var comments: [Comment]?
    
    // Default init
    init(author: Redditor, creationDate: Date, id: String, subreddit: Subreddit, comments: [Comment]?, title: String, selftext: String, url: String) {
        self.author = author
        self.creationDate = creationDate
        self.id = id
        self.subreddit = subreddit
        self.comments = comments
        self.title = title
        self.selftext = selftext
        self.urlValue = url
    }
    
    // Create a Comment for a Submission
    func reply() {}
    func upvote() {}
    func downvote() {}
    
}
