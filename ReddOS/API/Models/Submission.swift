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
    
    /// The value of the URL the submission links to if it contains media, else the link to the submission itself When attempting to load an image for a
    /// submission, first check if it exists via the `hasImage` property, then load asynchronously.
    var urlValue: String
    
    /// Whether or not this submission contains an image in its content
    var hasImage: Bool
    
    /// The Subreddit this Submission was posted in
    var parentSubredditName: String
    
    /// More formal data structure needs to be defined in the future (somthing like PRAW's CommentForest)
    var comments: [Comment]?
    
    // MARK: Initialization
    /**
     Default init
     */
    init(authorName: String, creationDate: Date, id: String, parentSubredditName: String, title: String, selftext: String, urlValue: String, hasImage: Bool, userScore: Int, totalScore: Int) {
        self.authorName = authorName
        self.creationDate = creationDate
        self.parentSubredditName = parentSubredditName
        self.title = title
        self.selftext = selftext
        self.urlValue = urlValue
        self.hasImage = hasImage
        super.init(contentType: .link, id: id, userScore: userScore, totalScore: totalScore)
    }
    
}

enum ImageState {
    case exists
    case isDownloading
    case hasNoImage
}
