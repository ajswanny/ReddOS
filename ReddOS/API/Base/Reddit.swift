//

//  Reddit.swift
//  ReddOS
//
//  Created by Alexander Swanson on 3/13/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import Foundation
import UIKit

public enum RedditError: Error {
    case userNotAuthenticated
    case authorizationExpired
    case networkConnectionLost
}

class Reddit {
    
    // MARK: Properties
    /// Host to make requests after a user is authenticated
    public final var host = "https://oauth.reddit.com"
    
    /// Host for images hosted on Reddit
    public final var imagesHost = "i.redd.it"
    
    /// Reference to the authentication controller
    var authenticationController: AuthenticationController
    
    /// Authenticated user
    var user: User?
    
    // MARK: Typealiases
    public typealias ReplyCompletionHandler  = (Error?) -> Void
    public typealias VoteCompletionHandler = (Error?) -> Void
    public typealias LoadUserFrontCompletionHandler = ([Submission]?, Error?) -> Void
    public typealias LoadBlockedRedditorsCompletionHandler = ([String]?, Error?) -> Void
    public typealias LoadUserSubscriptionsCompletionHandler = ([Subreddit]?, Error?) -> Void
    public typealias LoadUserFriendsCompletionHandler = ([String]?, Error?) -> Void
    public typealias InitUserDataCompletionHandler = ([String: Any]?, Error?) -> Void
    
    // MARK: Initialization
    /**
     Default init
     */
    public init(authenticationController: AuthenticationController) {
        self.authenticationController = authenticationController
        self.user = User()
    }
    
    /**
     Validate a user authentication session
     */
    private func validateUserSession() throws {
        
        // Ensure user is authenticated
        if !authenticationController.userIsAuthorizedForAuthentication {
            throw RedditError.userNotAuthenticated
        }
        guard let userSession = authenticationController.userSession else {
            throw RedditError.userNotAuthenticated
        }
        
        // Ensure user session is within authentication time limit
        if !userSession.isWithinTimeLimit {
            throw RedditError.authorizationExpired
        }
        
    }
    
    // MARK: User
    /**
     Initializes all necessary user data.
     Calls the API endpoints: me, friends, subscriptions, blocked, inbox, front.
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func initializeUserData(completionHandler: @escaping InitUserDataCompletionHandler) throws {
        
        // Validate session
        try validateUserSession()
        
        // Fetch "me"
        let meEndpoint = APIEndpoint(base: .me)
        guard let meRequest = newUrlRequest(method: .get, endpoint: meEndpoint) else {
            throw RedditError.userNotAuthenticated
        }
    
        // Execute and return unpacked data as as dict of Any ([String : Any])
        execute(meRequest) { body, error in
            if let body = body {
                // Convert to User properties
                guard
                    let username = body["name"] as? String,
                    let linkKarma = body["link_karma"] as? Int,
                    let commentKarma = body["comment_karma"] as? Int,
                    let profilePictureURL = body["icon_img"] as? String
                else {
                    fatalError()
                }
                
                self.user?.username = username
                self.user?.karma = linkKarma + commentKarma
                self.user?.profilePictureUrl = profilePictureURL
                let userData: [String: Any] = ["username": username, "karma": linkKarma + commentKarma, "profilePictureURL": profilePictureURL]
                completionHandler(userData, nil)
                
            } else {
                completionHandler(nil, error)
            }
        }
        
    }
    
    // MARK: User Subscriptions
    /**
     Executes a call to the Reddit API to fetch all the Subreddits the currently authenticated user is subscribed to.
     */
    public func loadUserSubscriptions(completionHandler: @escaping LoadUserSubscriptionsCompletionHandler) throws {
        
        // Validate session
        try validateUserSession()
        
        // Fetch "subscriptions"
        let subscriptionsEndpoint = APIEndpoint(base: .subscriptions)
        let subscriptionsRequest = newUrlRequest(method: .get, endpoint: subscriptionsEndpoint)
        
        // Execute and return unpacked data as as dict of Any ([String : Any])
        guard let request = subscriptionsRequest else {
            throw RedditError.userNotAuthenticated
        }
        execute(request) { body, error in
            if let body = body {
                
                // Convert to list of Subreddits
                let subreddits = self.parseUserSubscriptions(fromData: body)
                self.user?.subscriptions = subreddits
                completionHandler(subreddits, nil)
                
            } else {
                completionHandler(nil, error)
            }
        }
        
    }
    
    /**
     Parses raw dictionaries into a list of Subreddits
     */
    private func parseUserSubscriptions(fromData data: [String: Any]) -> [Subreddit] {
        
        //Get list of raw values
        guard let data = data["data"] as? [String: Any], let subreddits = data["children"] as? [[String: Any]] else { fatalError() }
        
        // Parse data
        var subredditObjects = [Subreddit]()
        for subreddit in subreddits {
            guard let subredditData = subreddit["data"] as? [String: Any] else { fatalError() }
            let fullname = subredditData["name"] as! String
            let displayName = subredditData["display_name"] as! String
            let headerImgURL = subredditData["header_img"] as? String ?? nil
            let newSubreddit = Subreddit(fullName: fullname, displayName: displayName, headerImgURL: headerImgURL)
            subredditObjects.append(newSubreddit)
        }
        
        return subredditObjects
        
    }
    
    // MARK: Blocked Redditors
    /**
     Executes a call to the Reddit API to fetch all the blocked redditors for the currently authenticated user.
     */
    public func loadUserBlockedRedditors(completionHandler: @escaping LoadBlockedRedditorsCompletionHandler) throws {
        
        // Validate session
        try validateUserSession()
        
        // Fetch "blocked"
        let blockedEndpoint = APIEndpoint(base: .blockedRedditors)
        guard let blockedRedditorsRequest = newUrlRequest(method: .get, endpoint: blockedEndpoint) else {
            throw RedditError.userNotAuthenticated
        }
        execute(blockedRedditorsRequest) { body, error in
            if let body = body {
                
                // Convert to list of blocked redditors
                let blockedRedditors = self.parseBlockedRedditors(fromData: body)
                self.user?.blockedRedditors = blockedRedditors
                completionHandler(blockedRedditors, nil)
                
            } else {
                completionHandler(nil, error)
            }
        }
        
    }
    
    /**
     Parses raw dictionaries into a list of the names of the redditors the authenticated user has blocked
     */
    private func parseBlockedRedditors(fromData data: [String: Any]) -> [String] {
        
        // Validate
        guard let data = data["data"] as? [String: Any], let blockedRedditorsData = data["children"] as? [[String: Any]] else { fatalError() }
        
        // Parse
        var blockedRedditors = [String]()
        for blockedRedditorData in blockedRedditorsData {
            let username = blockedRedditorData["name"] as! String
            blockedRedditors.append(username)
        }
        
        return blockedRedditors
        
    }
    
    // MARK: User Front
    /**
     Executes a call to the Reddit API to fetch all the Submissions in the currently authenticated user's front page.
     */
    public func loadUserFront(completionHandler: @escaping LoadUserFrontCompletionHandler) throws {
        
        // Validate session
        try validateUserSession()
        
        // Fetch "front"
        let frontEndpoint = APIEndpoint(base: .front)
        guard let frontRequest = newUrlRequest(method: .get, endpoint: frontEndpoint) else {
            throw RedditError.userNotAuthenticated
        }
        
        // Execute and return unpacked data as as a list of Submissions
        execute(frontRequest) { body, error in
            if let body = body {
    
                let front = self.parseUserFront(fromData: body)
                self.user?.front = front
                completionHandler(front, nil)
                
            } else {
                completionHandler(nil, error)
            }
        }
        
    }
    
    /**
     Parses submission data into a list of submission objects
     */
    private func parseUserFront(fromData data: [String: Any]) -> [Submission] {
        
        // Get list of Submission data
        guard let data = data["data"] as? [String: Any], let submissionData = data["children"] as? [[String: Any]] else { fatalError() }
        
        // Parse data into Submission objects
        var submissions = [Submission]()
        for submissionData in submissionData {

            guard let submissionData = submissionData["data"] as? [String: Any] else { fatalError() }
            let newSubmission = parseSubmission(fromData: submissionData)
            submissions.append(newSubmission)
            
        }
        
        return submissions
        
    }
    
    private func parseSubmission(fromData submissionData: [String: Any]) -> Submission {
        
        // Base values
        let authorName = submissionData["author"] as! String
        let creationDate = Date(timeIntervalSince1970: submissionData["created_utc"] as! Double)
        let id = submissionData["name"] as! String
        let parentSubredditName = submissionData["subreddit_name_prefixed"] as! String
        let title = submissionData["title"] as! String
        let selftext = submissionData["selftext"] as! String
        
        // User and total score
        var userScore: Int {
            if let value = submissionData["likes"] as? Bool {
            if value {
                return 1
            } else {
                return -1
                }
            }else{
                return 0
            }
        }
        let totalScore = submissionData["score"] as! Int
        
        // URL value
        let urlValue = submissionData["url"] as! String
        let url = URL(string: urlValue)
        let domain = url?.host
        var hasImage = false
        if domain == imagesHost {
            hasImage = true
        }
        
        // Create the new submission object and return it
        let newSubmission = Submission(authorName: authorName, creationDate: creationDate, id: id, parentSubredditName: parentSubredditName, title: title, selftext: selftext, urlValue: urlValue, hasImage: hasImage, userScore: userScore, totalScore: totalScore)
        
        return newSubmission
        
    }
    
    // MARK: Vote
    /**
     Vote on a submission or comment, providing the direction (-1: downvote, 0: unvote, 1: upvote).
     - Parameters:
        - completionHandler: The callback for when this request completes.
     */
    public func vote(onRedditContent redditContent: RedditContent, inDirection direction: Int, completionHandler: @escaping VoteCompletionHandler) throws {
        
        // Validate session
        try validateUserSession()
        
        
        // Construct the request
        let endpointParameters: [String: Any] = ["id": redditContent.id, "direction": direction]
        let voteEndpoint = APIEndpoint(base: .vote, parameters: endpointParameters)
        guard let voteRequest = newUrlRequest(method: .get, endpoint: voteEndpoint) else {
            throw RedditError.userNotAuthenticated
        }
        
        // Execute the request
        execute(voteRequest) {  data, error in
            
            // Validate
            if error == nil {
                completionHandler(nil)
            } else {
                fatalError()
            }
            
        }
        
    }
    
    // MARK: Reply
    /**
     Reply to a comment (comment on a comment), submission (comment on a submission) or a private message
     - Parameters:
        - completionHandler: The callback for when this request completes
     */
    public func reply(to target: Replyable, withContent content: String, completionHandler: @escaping ReplyCompletionHandler) {
        // TODO: Implement
        
    }
    
    // MARK: Methods
    /**
     Creates a new HTTP request.
     - Parameters:
        - method: GET or POST.
        - endpoint: The URL for the request to create.
     - Returns: The newly created URL request.
     */
    public func newUrlRequest(method: HTTPRequestType, endpoint: APIEndpoint) -> URLRequest? {
        
        // Init the URL request
        let url = URL(string: endpoint.fullEndpoint)!
        var request = URLRequest(url: url)

        // Set request method and metadata
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("TEST", forHTTPHeaderField: "User-Agent")

        // Set authorization values
        guard let accessToken = authenticationController.activeSession?.accessToken else {
            return nil
        }
        let authorizationString = "bearer \(accessToken)"
        request.setValue(authorizationString, forHTTPHeaderField: "Authorization")

        return request
        
    }
    
    // MARK: Request Execution
    /**
     Executes a URL request for Reddit API, unpacks, and returns result to a provided completion  handler
     - Parameters:
        - request: The URL request to execeute.
        - completion: The function to call when encountering an error or completiong the request.
        - observe: If the progress of this request should be observed.
     */
    private func execute(_ request: URLRequest, completion: @escaping ([String: Any]?, Error?) -> Void, observe: Bool = true) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            }
            
            // Verify a desirable response was received and unwrap
            guard
                let _ = response as? HTTPURLResponse,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let package = json as? [String: Any]
            else {
                fatalError()
            }
            
            // Return data
            completion(package, nil)
            
        }
        
        // Set observation if requested
        if observe {
            requestObservation = task.progress.observe(\.fractionCompleted, changeHandler: changeHandler)
        }
        
        task.resume()
        
    }
    
    // MARK: Request Observation
    private var requestObservation: NSKeyValueObservation?
    func changeHandler(progress: Progress, observedChange: NSKeyValueObservedChange<Double>) {
        #if DEBUG
        print("Progress for \(progress.fileURL?.absoluteString ?? "unknown resource"): ", progress.fractionCompleted)
        #endif
        if progress.fractionCompleted == 1.0 {
            requestObservation?.invalidate()
        }
    }
    
}
