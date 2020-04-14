//
//  HomeDetailViewController.swift
//  ReddOS
//
//  Created by JJ Thissell on 3/25/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import UIKit

class HomeDetailViewController : UIViewController {
    
    @IBOutlet weak var bodySummarySubmission : UILabel!
    @IBOutlet weak var upVote : UIButton!
    @IBOutlet weak var downVote : UIButton!
    @IBOutlet weak var totalVotes : UILabel!
    
    //
    var reddit: Reddit!
    
    //TODO: put subreddit title on navigation bar
    var submission: Submission! {
        didSet{
            navigationItem.title = submission.parentSubredditName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bodySummarySubmission.text = submission!.selftext
        totalVotes.text = "\(submission.totalScore)"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Submission Vote
    
    //TODO: complete this
    func VoteCompletionHandler(error: Error?){
       
    }

    //actions for upVote and downVote button
    @IBAction func upVoteSub(_ upVote: UIButton){

        //if the totalScore is 0 or -1
        if(submission.userScore == 0 || submission.userScore == -1){
            //enable it
            upVote.isEnabled = true
            //try to vote
            try! reddit.vote(onRedditContent: submission, inDirection: 1, completionHandler: VoteCompletionHandler(error:))
        
            submission.totalScore += 1
            totalVotes.text = "\(submission.totalScore)"
            print(submission.totalScore)
            
        }

        //notify user has voted
       else if(submission.isUpvoted){
            //disable button
            upVote.isEnabled = false
        }
    }

    @IBAction func downVoteSub(_ downVote: UIButton){
        //if the totalScore is 0 or 1
        if(submission.userScore == 0 || submission.userScore == 1){
            //enable it
            downVote.isEnabled = true
            //try to vote
            try! reddit.vote(onRedditContent: submission, inDirection: -1, completionHandler: VoteCompletionHandler(error:))
            
            submission.totalScore -= 1
            totalVotes.text = "\(submission.totalScore)"
            print(submission.totalScore)
        }

        //notify user has voted
        else if(submission.isDownvoted){
            //disable button
            downVote.isEnabled = false
        }
    }

}
