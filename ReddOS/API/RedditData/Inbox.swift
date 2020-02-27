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
    
    var commentReplies: [Comment]?
    var privateMessages: [Message]?
    
    // Default init
    init(commentReplies: [Comment]?, privateMessages: [Message]?) {
        self.commentReplies = commentReplies
        self.privateMessages = privateMessages
    }
    
    // Send a message from current user to a recipient
    func sendMessage(recipient: Redditor) {}
    
    // Marking messages/comment replies as read dismisses them from Inbox
    func markAsRead(commentReply: Comment) {}
    func markAsRead(privateMessage: Message) {}
    
    // Fetch new received Messages/Comment replies
    func refresh() {}
    
}
