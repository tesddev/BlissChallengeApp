//
//  AppleReposViewController.swift
//  BlissChallengeApp
//
//  Created by GIGL iOS on 07/08/2022.
//

import UIKit

class AppleReposViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var appleReposTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = Constants.AppColors.backgroundColor
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.AppColors.backgroundColor
        appleReposTableView.dataSource = self
        appleReposTableView.delegate = self
        view.addSubview(appleReposTableView)
        appleReposTableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.backgroundColor = Constants.AppColors.backgroundColor
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.text = "Tes"
        return cell ?? UITableViewCell()
    }
}
