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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return hotSubmissions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotThread", for: indexPath)
        let submisson = hotSubmissions[indexPath.row]
        cell.textLabel!.text = submisson.title
       // cell.textLabel?.text = submisson.subreddit
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

