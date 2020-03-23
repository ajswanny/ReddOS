//
//  AuthenticationSession.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/23/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 Relates guest and user authentication sessions
 */
protocol AuthenticationSession {
    
    /// Username of the authenticated account
    var username: String? { get set }
    
}
