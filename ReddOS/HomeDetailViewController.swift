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
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
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
    
    //TODO: Reload TableView data 
    func VoteCompletionHandler(error: Error?){

        
    }
    
    //actions for upVote and downVote button
    @IBAction func upVoteSub(_ upVote: UIButton){
        //if the totalScore is 0 or -1
        if(submission.userScore == 0 || submission.userScore == -1){
            print(submission.userScore)

            //try to vote
            do {
                try reddit.vote(onRedditContent: submission, inDirection: 1, completionHandler: VoteCompletionHandler(error:))
            } catch {
                print(error.localizedDescription)
            }
            
            if(submission.userScore == -1){
                submission.userScore += 1
                //submission.totalScore += 1
                
                upVote.isEnabled = true
                
            }
            else{
                submission.totalScore += 1
                submission.userScore += 1
                totalVotes.text = "\(submission.totalScore)"
                print(submission.userScore)
                upVote.isEnabled = false
                downVote.isEnabled = true
                //print(submission.totalScore)
            }
        }
    }
    
    @IBAction func downVoteSub(_ downVote: UIButton){
        //if the totalScore is 0 or 1
        if(submission.userScore == 0 || submission.userScore == 1){
            print(submission.userScore)
            
            
            //try to vote
            try! reddit.vote(onRedditContent: submission, inDirection: -1, completionHandler: VoteCompletionHandler(error:))
            
            //label shouldn't change if it zero
            if(submission.userScore == 1){
                submission.userScore -= 1
                downVote.isEnabled = true
            }
            else{
                //update the label
                submission.totalScore -= 1
                submission.userScore -= 1
                totalVotes.text = "\(submission.totalScore)"
                print(submission.totalScore)
                downVote.isEnabled = false
                upVote.isEnabled = true
                //  downVote.isEnabled = false
                
            }
            
        }
        
    }
    
}
