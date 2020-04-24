//
//  RedditObject.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/20/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 Defines the properties that a Comment or Submission must have.
 */
class RedditContent {
    
    // MARK: Properties
    /// The type of reddit content.
    var redditContentType: RedditContentType
    
    /// A necessary ID to identify this object and allow the API to interact with it
    var id: String
    
    var fullname: String {
        return redditContentType.rawValue + self.id
    }
    
    /// The score respective to the user
    var userScore: Int
    
    /// The total score of the user
    var totalScore: Int
    
    /// Whether or not the user has upvoted this submission
    var isUpvoted: Bool {
        get {
            if userScore == 0 || userScore == -1 {
                return false
            } else {
                return true
            }
        }
    }
    
    /// Whether or not the user has downvoted this submission
    var isDownvoted: Bool {
        get {
            if userScore == 0 || userScore == 1 {
                return false
            } else {
                return true
            }
        }
    }
    
    // MARK: Initialization
    /**
     Default init
     */
    init(contentType: RedditContentType, id: String, userScore: Int, totalScore: Int) {
        self.redditContentType = contentType
        self.id = id
        self.userScore = userScore
        self.totalScore = totalScore
    }
    
}
