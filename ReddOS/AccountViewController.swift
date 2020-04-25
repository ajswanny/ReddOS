//
//  AccountViewController.swift
//  ReddOS
//
//  Created by Matthew Zahar on 3/10/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import UIKit
import AuthenticationServices

class AccountViewController: UIViewController, ASWebAuthenticationPresentationContextProviding, UIViewControllerTransitioningDelegate, UITableViewDataSource {
    
    var subReddits: [Subreddit] = []
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profilepic: UIImageView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subReddits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let(subReddit) = subReddits [indexPath.row]
        
        cell.textLabel?.text = subReddit.displayName
        return cell
    }
    
    /// Is set to true when it is ok to make API calls.
    var canMakeAPICalls: Bool = false
    
    /// The application delegate.
    let delegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
       do {
            try delegate.reddit?.loadUserSubscriptions(completionHandler: completionHandler(data:error:))
        } catch {
            print(error.localizedDescription)
        }
        
        if let profilePicURLValue = delegate.reddit?.user?.profilePictureUrl,
            let profilePicURL = URL(string: profilePicURLValue) {
            profilepic.load(url: profilePicURL)
        } else {
            #if DEBUG
            print("Could not load user's profile picture")
            #endif
            
        }
        
    }
    /**
     An example listener for an 'onAuthenticated' notification. The AuthenticationController posts this notification and adding a listener allows one to know when the app has logged in, thus being
     able to then perform API calls. Essentially, this notification acts as a greenlight to now perform API calls.
     */
    
    //take data optional and error otional
    func completionHandler(data: [Subreddit]?, error: Error?) -> Void {
        
        // Validate data
        guard let submissionList = data, error == nil else {
            fatalError()
        }
        
        // Redefine data
        subReddits = submissionList
        print(subReddits)
        
        // Reload UI
        DispatchQueue.main.async {
            self.table.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    
    //subreddits objects classes and models
    
    /**
     Tests new-user login.
     */
    @IBAction func testLoggingInForNewUser(_ sender: Any) {
        delegate.authenticationController?.authenticateNewUser(fromView: self)
    }
    
    /**
     Tests logout.
     */
    @IBAction func testLoggingOutForUser(_ sender: Any) {
        delegate.authenticationController?.logoutUserSession()
        print("log out")
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
     Necessary function in order to be able to call the AuthenticationView from this view
     */
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    
    /**
     Menu View
     */
    
    @IBAction func listButton(_ sender: UIBarButtonItem) {
        if (table.isHidden){
            table.isHidden = false
        } else {
            table.isHidden = true
        }
    }
}


