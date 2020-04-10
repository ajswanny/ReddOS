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
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotThread", for: indexPath)
        let submisson = hotSubmissions[indexPath.row]
        cell.textLabel!.text = submisson.title
        cell.textLabel!.text = submisson.parentSubredditName
        //cell.textLabel?.text = submisson.subreddit
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
    @IBOutlet weak var upVote: UIButton!
    @IBOutlet weak var downVote: UIButton!
    
}

