//
//  AuthenticationEnums.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/17/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/// An enumeration of the possible parameters in a callback URL
public enum CallbackParameters: String {
    case code
    case state
    case error
}

/// An enumeration of the possible values for a callback error
public enum CallbackError: String {
    case access_denied
    case unsupported_response_type
    case invalid_scope
    case invalid_request
}
