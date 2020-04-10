//
//  Message.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/27/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 Implementation of a private message sent to a Redditor.
 */
@available(*, deprecated, message: "Removed due to drop of Inbox functionality.")
class Message: Replyable {
    
    // MARK: Properties
    /// A necessary ID to identify this object and allow the API to interact with it
    var id: String
    
    /// Username of the author of this message
    var authorName: String
    
    /// Date this message was created and sent
    var creationDate: Date
    
    /// Username of the recipient of this message
    var recipientName: String
    
    /// The subject of the message
    var subject: String
    
    /// The content of the message
    var content: String
    
    // MARK: Initialization
    /**
     Default init
     */
    init(id: String, authorName: String, creationDate: Date, recipientName: String, subject: String, body: String) {
        self.id = id
        self.authorName = authorName
        self.creationDate = creationDate
        self.recipientName = recipientName
        self.subject = subject
        self.content = body
    }
    
}
