//
//  UserAuthenticationSession.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/23/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

class UserAuthenticationSession: AuthenticationSession {
    
    // MARK: Properties
    /// Username of the authenticated account
    var username: String?
    
    /// Access scope for the authenticated user
    var scope: String?
    
    /// The refresh token retrieved during the initial request for an access token
    var refreshToken: String?
    
    /// Token for access when making API calls
    var accessToken: String?
    
    /// Should be the string "bearer"
    var tokenType: String?
    
    /// Expiration date of the access token
    var expirationDate: Date?
    
    // MARK: Initialization
    init() {
    }
    
}
