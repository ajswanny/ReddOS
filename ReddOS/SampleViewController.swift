//
//  SecondViewController.swift
//  ReddOS
//
//  Created by Alexander Swanson on 1/28/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import UIKit
import AuthenticationServices

class SampleViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    /// Is set to true when it is ok to make API calls.
    var canMakeAPICalls: Bool = false
    
    /// The application delegate.
    let delegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // An example notification listener
        NotificationCenter.default.addObserver(self, selector: #selector(exampleAuthenticationCompleteListener), name: .onAuthenticated, object: nil)
        
    }
    
    /**
     An example listener for an 'onAuthenticated' notification. The AuthenticationController posts this notification and adding a listener allows one to know when the app has logged in, thus being
     able to then perform API calls. Essentially, this notification acts as a greenlight to now perform API calls.
     */
    @objc private func exampleAuthenticationCompleteListener(notification: NSNotification) {
        
        // Set an instance variable to indicate successful retrieval of notification
        canMakeAPICalls = true
        
        // Perform some example calls
        do {
            try delegate.reddit?.loadUserFront() { data, error in
                print(data!.map { submission in submission.title })
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // Or, call a function to load and present all data like:
        // func makeAPICallAndPresentDataInUI()
        
    }

    /**
     Tests new-user login.
     */
    @IBAction func testLoggingInForNewUser(_ sender: Any) {
        delegate.authenticationController?.authenticateNewUser(fromView: self)
    }
    
    /**
     An example completion handler for a call to Reddit.loadUserFront
     */
    func completionExample(data: [Submission]?, error: Error?) {
        guard let submissionList = data else {
            fatalError()
        }
        // Use 'submissionList'
        for submission in submissionList {
            print(submission.title)
        }
    }
    
    /**
     Tests  a bunch of API calls.
     */
    @IBAction func testAPICalls(_ sender: UIButton) {
        
        do {
            
            // Run some random API calls for testing
            try delegate.reddit?.initializeUserData() { data, error in print(data!) }
            try delegate.reddit?.loadUserSubscriptions() { data, error in print(data!.map { subreddit in subreddit.displayName}) }
            try delegate.reddit?.loadUserBlockedRedditors() { data, error in print(data!) }
            try delegate.reddit?.loadUserFront() { data, error in print(data!.map { submission in submission.title }) }
            try delegate.reddit?.loadUserFront(completionHandler: completionExample(data:error:))

        } catch {
            print(error)
        }
        
    }
    
    /**
     Necessary function in order to be able to call the AuthenticationView from this view
     */
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}

