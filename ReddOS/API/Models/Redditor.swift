//
//  Redditor.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 A baseic implementation of a Redditor.
 */
class Redditor {
    
    // MARK: Properties
    /// The username
    var username: String
    
    /// The total karma of this Redditor
    var karma: Int
    
    /// A list of friends
    var friends: [Redditor]
    
    /// The link to this Redditor's URL. This value will be dynamically loaded
    var profilePictureUrl: String? {
        didSet {
            // Implement instantiation of profilePicture here
        }
    }
    
    /// Actual profile picture data that can be converted to a UIImage
    var profilePicture: Data?
    
    // MARK: Initialization
    /**
     Default init
     */
    init(username: String, karma: Int, friends: [Redditor]) {
        self.username = username
        self.karma = karma
        self.friends = friends
    }
    
}
