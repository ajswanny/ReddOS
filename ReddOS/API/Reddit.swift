//
//  Reddit.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/13/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

/**
 These prefixes are used when communicating with the Reddit API in order to identify a specific kind of Reddit ocject.
 */
public struct ObjectTypePrefixes {
    static let comment = "t1_"
    static let account = "t2_"
    static let link = "t3_"
    static let message = "t4_"
    static let subreddit = "t5_"
    static let award = "t6_"
}

public struct DebugAccount {
    static let username = "reddosmanagers"
    static let password = "reddosAccount!"
    static let userAgent = "local:dev:test_service"
    static let clientId = "yp2zn5DCzETdJw"
    static let clientSecret = "k_TPBkSTUoIFnaWPA1080gLz9Mc"
}
