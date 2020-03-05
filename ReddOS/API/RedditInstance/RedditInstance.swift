//
//  Reddit.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/5/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

class RedditInstance {
    
    var user: User?
    
//    func getDebugAccount() -> User {
//
//    }
    
    init() {
        print("RedditInstance initialized")
    }
    
}

struct DebugAccount {
    let username = "reddosmanagers"
    let password = "reddosAccount!"
    let userAgent = "local:dev:test_service"
    let clientId = "yp2zn5DCzETdJw"
    let clientSecret = "k_TPBkSTUoIFnaWPA1080gLz9Mc"
    
    init() {}
}
