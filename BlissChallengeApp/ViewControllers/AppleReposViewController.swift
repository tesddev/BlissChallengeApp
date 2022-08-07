//
//  AppleReposViewController.swift
//  BlissChallengeApp
//
//  Created by GIGL iOS on 07/08/2022.
//

import UIKit

class AppleReposViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var repos = [AppleURLInput]()
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
        appleReposTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Constants.AppColors.backgroundColor
        NetworkManager.shared.getAppleRepos(page: 1, size: 10) { element in
            print(element)
            switch element {
            case .success(let urls):
                let arrayOfURLs = Array(urls)
                self.repos = arrayOfURLs.compactMap({ elem in
                    AppleURLInput(
                        url: elem.name
                    )
                })
                print(self.repos.count)
                print("here is \(self.repos[0].url)")
                DispatchQueue.main.async {
                    self.appleReposTableView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.backgroundColor = Constants.AppColors.backgroundColor
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.text = self.repos[indexPath.row].url
        return cell ?? UITableViewCell()
    }
}
