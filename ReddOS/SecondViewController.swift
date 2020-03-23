//
//  SecondViewController.swift
//  ReddOS
//
//  Created by Alexander Swanson on 1/28/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import UIKit
import AuthenticationServices

class SecondViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func test(_ sender: Any) {
    delegate.authenticationController?.authenticateNewUser(fromView: self)
        
    }
    
}

