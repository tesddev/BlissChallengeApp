//
//  AppleReposViewController.swift
//  BlissChallengeApp
//
//  Created by TES on 07/08/2022.
//

import UIKit

class AppleReposViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var repos = [AppleURLInput]()
    var reusableArray = [AppleURLInput]()
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
    
    func populateTable(){
        NetworkManager.shared.getAppleRepos(page: 1, size: 10) {[weak self] element in
            switch element {
            case .success(let urls):
                let arrayOfURLs = Array(urls)
                self?.reusableArray = arrayOfURLs.compactMap({ data in
                    AppleURLInput(
                        url: data.name
                    )
                })
                let reusableArr = self?.reusableArray[...9]
                self?.reusableArray.removeSubrange(...9)
                guard reusableArr != nil else { return }
                self?.repos.append(contentsOf: reusableArr!)
                DispatchQueue.main.async {
                    self?.appleReposTableView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Constants.AppColors.backgroundColor
        populateTable()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.backgroundColor = Constants.AppColors.backgroundColor
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.text = self.repos[indexPath.row].url
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var page = 2
        let lastElement = self.repos.count - 1
            if indexPath.row == lastElement {
                // logic here
                beginFetch(in: page)
                page += 1
            }
    }
    
    func beginFetch(in page: Int){
        
        if reusableArray.count < 10 {
            ///  call API and add more data to reusable array
            NetworkManager.shared.getAppleRepos(page: page, size: 10) {[weak self] element in
                switch element {
                case .success(let urls):
                    let arrayOfURLs = Array(urls)
                    self?.reusableArray = arrayOfURLs.compactMap({ elem in
                        AppleURLInput(
                            url: elem.name
                        )
                    })
                    let reusableArr = self?.reusableArray[...9]
                    self?.reusableArray.removeSubrange(...9)
                    guard reusableArr != nil else { return }
                    self?.repos.append(contentsOf: reusableArr!)
                    DispatchQueue.main.async {
                        self?.appleReposTableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            }
                
        } else {
            /// get 10 data from reusable array and pass to repos to be displayed on table view
            let reusableArr = self.reusableArray[...9]
            self.reusableArray.removeSubrange(...9)
            self.repos.append(contentsOf: reusableArr)
            DispatchQueue.main.async {
                self.appleReposTableView.reloadData()
            }
        }
    }
}
