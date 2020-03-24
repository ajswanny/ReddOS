//
//  AuthenticationEnums.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/17/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 An enumeration of the possible parameters in a callback URL
 */
public enum CallbackParameter: String {
    
    /// A one-time use code that may be exchanged for a bearer token.
    case code
    
    /// This value should be the same as the one sent in the initial authorization request
    case state
    
    /// A variety of possible errors, specified in `CallbackError`
    case error
    
}

/**
 An enumeration of the possible values for a callback error
 */
public enum CallbackError: String {
    
    /// User chose not to grant the app permissions
    case access_denied
    
    /// Invalid `response_type` parameter in initial authorization
    case unsupported_response_type
    
    /// Invalid `scope` parameter in initial authorization
    case invalid_scope
    
    /// There was an issue with the request sent to `/api/v1/authorize`
    case invalid_request
    
}
