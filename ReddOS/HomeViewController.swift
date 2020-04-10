//
//  FirstViewController.swift
//  ReddOS
//
//  Created by Alexander Swanson on 1/28/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var hotSubmissions: [Submission]!

    let delegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //TODO: steps for getting user front data
       
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveAuthenticationNotification), name: .onAuthenticated, object: nil)
        
    }
    
    @objc func didReceiveAuthenticationNotification(notification: NSNotification){
        
        do {
            try delegate.reddit?.loadUserFront(completionHandler:completionHandler(data:error:))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    //take data optional and error otional
    func completionHandler(data: [Submission]?, error: Error?) -> Void {
        
        // Validate data
        guard let submissionList = data, error == nil else {
            fatalError()
        }
        
        // Redefine data
        hotSubmissions = submissionList
        
        // Reload UI
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return hotSubmissions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotThread", for: indexPath) as! HomeViewCell
        let submisson = hotSubmissions[indexPath.row]
        cell.hotThreadTitle!.text = submisson.title
        cell.hotThreadSubReddit.text = submisson.parentSubredditName
        cell.totalVote.text = "\(submisson.totalScore)"
//        print(submisson.totalScore)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        87
    }

}

class HomeViewCell: UITableViewCell {
    @IBOutlet weak var hotThreadImage: UIImageView!
    @IBOutlet weak var hotThreadTitle: UILabel!
    @IBOutlet weak var hotThreadSubReddit: UILabel!
    @IBOutlet weak var totalVote: UILabel!

}

