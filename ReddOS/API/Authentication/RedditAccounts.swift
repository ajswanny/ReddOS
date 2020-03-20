//
//  RedditAccounts.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/20/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/// Account to use for debugging
public struct DebugAccount {
    let username = "reddosmanagers"
    let password = "reddosAccount!"
    let userAgent = "local:dev:test_service"
    let clientId = "yp2zn5DCzETdJw"
    let clientSecret = "k_TPBkSTUoIFnaWPA1080gLz9Mc"
}

/// Account to use for a guest session
public struct GuestUserAccount {
    let username = ""
    let password = ""
    let userAgent = ""
    let clientId = ""
    let clientSecret = ""
}
