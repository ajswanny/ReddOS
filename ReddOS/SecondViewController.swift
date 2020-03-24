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
    
    @IBAction func testAPICalls(_ sender: UIButton) {
        
        do {
            try delegate.reddit?.initializeUserData() { data, error in
                print("success")
            }
        } catch {
            print(error)
        }
        
//        guard let url = URL(string: "https://oauth.reddit.com/api/v1/me") else {
//            fatalError()
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        guard let accessToken = delegate.authenticationController?.activeSession?.accessToken else {
//            fatalError()
//        }
//        let authorizationString = "bearer \(accessToken)"
//        request.setValue(authorizationString, forHTTPHeaderField: "Authorization")
//
//        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
//            guard
//                let _ = response as? HTTPURLResponse,
//                let data = data,
//                let json = try? JSONSerialization.jsonObject(with: data, options: []),
//                let package = json as? [String: Any]
//                else {
//                    fatalError()
//            }
//
//        }
//        task.resume()
//
        
    }
    
    
}

