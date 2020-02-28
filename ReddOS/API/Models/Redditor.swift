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
    
    var username: String
    var karma: Int
    var friends: [Redditor]
    
    // This value will be dynamically loaded
    var profilePictureUrl: String? {
        didSet {
            // Implement instantiation of profilePicture here
        }
    }
    
    // Actual profile picture data that can be converted to UIImage
    var profilePicture: Data?
    
    init(username: String, karma: Int, friends: [Redditor]) {
        self.username = username
        self.karma = karma
        self.friends = friends
    }
    
}
