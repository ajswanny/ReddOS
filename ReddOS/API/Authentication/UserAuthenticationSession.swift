//
//  UserAuthenticationSession.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/23/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

class AuthenticationSession: NSObject, NSCoding {
    
    // MARK: Properties
    
    /// The refresh token retrieved during the initial request for an access token
    var refreshToken: String?
    
    /// Token for access when making API calls
    var accessToken: String?
    
    /// Should be the string "bearer"
    var tokenType: String?
    
    /// Expiration date of the access token
    var expirationDate: Date?
    
    /// Whether or not this session is within safe time limit
    var isWithinTimeLimit: Bool {
        if let expirationDate = self.expirationDate {
            return expirationDate.timeIntervalSinceNow > 30
        } else {
            return false
        }
    }
    
    // MARK: Initialization
    /**
     
     */
    override init() {
        //
    }
//    
//    init(refreshToken: ) {
//        super.init()
//        
//    }
    
    /**
     
     */
    
    // MARK: Coding
    /**
     
     */
    func encode(with coder: NSCoder) {
        coder.encode(refreshToken, forKey: "refreshToken")
        coder.encode(accessToken, forKey: "accessToken")
        coder.encode(tokenType, forKey: "tokenType")
        coder.encode(expirationDate, forKey: "expirationDate")
    }
    
    /**
     
     */
    required init?(coder: NSCoder) {
        self.refreshToken = coder.decodeObject(forKey: "refreshToken") as? String
        self.accessToken = coder.decodeObject(forKey: "accessToken") as? String
        self.tokenType = coder.decodeObject(forKey: "tokenType") as? String
        self.expirationDate = coder.decodeObject(forKey: "expirationDate") as? Date
    }
    
    // MARK: Logout
    /**
     
     */
    public func logout() {
        refreshToken = nil
        accessToken = nil
        tokenType = nil
        expirationDate = nil
    }
    
}
