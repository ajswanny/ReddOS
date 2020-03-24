//
//  Inbox.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 Implementation of the `User`  inbox. Contains all messages and functionality to respond to them.
 */
class Inbox {
    
    // MARK: Properties
    /// The list of messages that are comments to this user's created content
    var commentReplies: [Comment]?
    
    /// The list of messages that are private messages
    var privateMessages: [Message]?
    
    // MARK: Initialization
    /**
     Default init
     */
    init(commentReplies: [Comment]?, privateMessages: [Message]?) {
        self.commentReplies = commentReplies
        self.privateMessages = privateMessages
    }
    
}
