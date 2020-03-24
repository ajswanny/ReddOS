//
//  Replyable.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/21/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 A protocol for reddit content that can be replied to: i.e., messages, comments, and submissions
 */
protocol Replyable {
    
    /// A necessary ID to identify this object and allow the API to interact with it
    var id: String { get set }
    
}
