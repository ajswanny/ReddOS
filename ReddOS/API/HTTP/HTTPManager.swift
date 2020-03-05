//
//  HTTPManager.swift
//  ReddOS
//
//  Created by Alexander Swanson on 2/29/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation

class HTTPManager {
    
    init() {
        print("Initialized HTTPManager")
        
    }
    
    
    // MARK: - Custom Types
    enum HttpMethod: String {
        case get
        case post
        case put
    }
    
    struct RestEntity {
        private var values: [String: String]
    }
    
}
