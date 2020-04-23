//
//  SlideOutMenu.swift
//  ReddOS
//
//  Created by Matthew Zahar on 4/22/20.
//  Copyright © 2020 SandPeople. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case home
    case camera
    case profile
}

class SlideOutMenu: UITableViewController{
    var didTapMenuType: ((MenuType) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }
}
