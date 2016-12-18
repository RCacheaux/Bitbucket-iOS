//
//  TeamListViewController.swift
//  Bitbucket
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import UIKit
import RxSwift
import BitbucketKit

class TeamListViewController: UITableViewController {
  var observable: Observable<[Team]>!
  var observableDisposable: Disposable?
  var teams: [Team] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    assert(observable != nil)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    observableDisposable = observable.subscribe(onNext: { teams in
      self.teams = teams
      self.tableView.reloadData()
    })
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    observableDisposable?.dispose()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return teams.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    cell.textLabel?.text = teams[indexPath.row].displayName
    return cell
  }
}
