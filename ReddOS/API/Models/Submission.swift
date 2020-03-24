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
class Submission: RedditContent {
    
    // MARK: Properties
    /// The username of the author
    var authorName: String
    
    /// The title of the submission.
    var title: String
    
    /// Time the submission was created
    var creationDate: Date
    
    /// The submission's selftext (the actual content) - an empty string if a link post.
    var selftext: String
    
    /// The URL the submission links to, or the permalink if a selfpost.
    var urlValue: String {
        didSet {
            // TODO: Implement detection and loading of URL (image of link)
        }
    }
    
    /// The Subreddit this Submission was posted in
    var parentSubreddit: Subreddit
    
    /// More formal data structure needs to be defined in the future (somthing like PRAW's CommentForest)
    var comments: [Comment]?
    
    // MARK: Initialization
    /**
     Default init
     */
    init(authorName: String, creationDate: Date, id: String, parentSubreddit: Subreddit, title: String, selftext: String, urlValue: String, userScore: Int, totalScore: Int) {
        self.authorName = authorName
        self.creationDate = creationDate
        self.parentSubreddit = parentSubreddit
        self.title = title
        self.selftext = selftext
        self.urlValue = urlValue
        super.init(id: id, userScore: userScore, totalScore: totalScore)
    }
    
}
