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
class Comment: RedditContent {
    
    // MARK: Properties
    /// The username of the author of this Comment
    var authorName: String
    
    /// The text content of this comment
    var body: String
    
    /// The Submission this Comment belongs to
    var submission: Submission
    
    /// Set of Comments that are replies to this Comment
    var replies: [Comment]? // TODO: More formal data structure needs to be defined in the future (somthing like PRAW's CommentForest)
 
    // MARK: Initialization
    /**
     Default init
     */
    init(authorName: String, body: String, id: String, submission: Submission, userScore: Int, totalScore: Int) {
        self.authorName = authorName
        self.body = body
        self.submission = submission
        super.init(contentType: .comment, id: id, userScore: userScore, totalScore: totalScore)
    }
    
}
