//
//  AuthenticationSession.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/17/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

class AuthenticationSession: NSObject {
    
    var refreshToken: String?
    
    var accessToken: String?
    
    /// "bearer"
    var tokenType: String?
    
    var expirationDate: Date?
     
    var scope: String?
    
    var username: String?
    
    override init() {
        super.init()
    }
    
    public func destroy() {
        refreshToken = nil
    }
    
}
