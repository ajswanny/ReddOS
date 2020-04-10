//
//  RedditContentPrefixes.swift
//  ReddOS
//
//  Created by Alexander Swanson on 4/10/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 These prefixes are used when communicating with the Reddit API in order to identify a specific kind of Reddit ocject.
 */
public enum RedditContentType: String {
    
    case comment = "t1_"
    
    case account = "t2_"
    
    /// Link, AKA, Submission
    case link = "t3_"
    
    case message = "t4_"
    
    case subreddit = "t5_"
    
    case award = "t6_"
    
}
