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
class Message {
    
    var author: Redditor
    var creationDate: Date
    var recipient: Redditor
    var subject: String
    var body: String
    
    // Default init
    init(author: Redditor, creationDate: Date, recipient: Redditor, subject: String, body: String) {
        self.author = author
        self.creationDate = creationDate
        self.recipient = recipient
        self.subject = subject
        self.body = body
    }
    
    func markAsRead() {}
    
}
