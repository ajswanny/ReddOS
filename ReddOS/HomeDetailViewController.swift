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
    @IBOutlet weak var subImagee : UIImageView!
    @IBOutlet weak var subTitle : UILabel!
    
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
        
        //handle case where submission has no text
        if(submission!.selftext == ""){
            bodySummarySubmission.text = submission.urlValue
            bodySummarySubmission.font = bodySummarySubmission.font.withSize(18)
            bodySummarySubmission.textColor = .link
            bodySummarySubmission.textAlignment = .center
        }
        else{
            bodySummarySubmission.text = submission!.selftext
        }
        
        totalVotes.text = "\(submission.totalScore)"
        subTitle.text = submission!.title
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(submission.hasImage){
            let url = URL(string: submission.urlValue)!
            subImagee.load(url: url)
        }
        
        // This is the key
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickLabel(sender:)))
           bodySummarySubmission.isUserInteractionEnabled = true
           bodySummarySubmission.addGestureRecognizer(tap)
    }
    
    
    //MARK: - Submission Vote
    
    //TODO: Reload TableView data 
    func VoteCompletionHandler(error: Error?){

        
    }
    
    //actions for upVote and downVote button
    @IBAction func upVoteSub(_ upVote: UIButton){
        //if the totalScore is 0 or -1
        if(submission.userScore == 0 || submission.userScore == -1){

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
                upVote.isEnabled = false
                downVote.isEnabled = true
            }
        }
    }
    
    @IBAction func downVoteSub(_ downVote: UIButton){
        //if the totalScore is 0 or 1
        if(submission.userScore == 0 || submission.userScore == 1){
            
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
                downVote.isEnabled = false
                upVote.isEnabled = true
                //  downVote.isEnabled = false
                
            }
            
        }
        
    }
    
    
    // And that's the function :)
    @objc func onClickLabel(sender:UITapGestureRecognizer) {
        openUrl(urlString: submission.urlValue)
    }
    
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}


//MARK: - Image
/**
 This extension allows for the download and automatic update of a image linked to by a URL.
 */
extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        // Can create a notification or print to notify of success
                        print("Successfully downloaded the image set to \(image)")
                    }
                } else {
                    print("Cannot download image")
                }
            }
        }
    }
    
}
