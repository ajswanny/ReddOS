//
//  MenuViewController.swift
//  ReddOS
//
//  Created by Matthew Zahar on 4/22/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource {
    var subReddits: [Subreddit] = [Subreddit]()

    let delegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //TODO: steps for getting user front data
        do {
            try delegate.reddit?.loadUserSubscriptions(completionHandler: completionHandler(data:error:))
            //.loadUserS(completionHandler:completionHandler(data:error:))
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
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
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return subReddits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subRedditCell", for: indexPath)
        let submisson = subReddits[indexPath.row]
        cell.textLabel!.text = submisson.displayName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        87
    }

    @IBAction func dismiss(_ sender: Any) {
         dismiss(animated: true) {}
    }
    
    @IBOutlet weak var subRedditName: UILabel!
}

       
    


