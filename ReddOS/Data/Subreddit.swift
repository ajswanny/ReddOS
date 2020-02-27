//
//  Subreddit.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 A `Subreddit` implementation.
 */
class Subreddit {
    
    // Technical name
    var fullName: String
    
    // Name publicly shown to users
    var displayName: String
    
    // The list of currently `Hot` Submissions
    var hotSubmissions: [Submission]
    
    // Default init
    init(fullName: String, displayName: String, hotSubmissions: [Submission]) {
        self.fullName = fullName
        self.displayName = displayName
        self.hotSubmissions = hotSubmissions
    }
    
}
