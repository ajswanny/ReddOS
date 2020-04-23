//
//  MenuViewController.swift
//  ReddOS
//
//  Created by Matthew Zahar on 4/22/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {}
    }
}
