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
  var teams: [Team] = []

  // In
  var observable: Observable<[Team]>!
  var observableDisposable: Disposable?

  // Out
  var makeRefreshUseCase: (() -> RefreshTeamsUseCase)!
  let queue = OperationQueue()

  override func viewDidLoad() {
    super.viewDidLoad()
    assert(observable != nil)
    assert(makeRefreshUseCase != nil)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    refreshControl?.addTarget(self, action: #selector(TeamListViewController.refresh), for: .valueChanged)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    observableDisposable = observable.subscribe(onNext: { teams in
      self.teams = teams
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
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

  func refresh() {
    let useCase = makeRefreshUseCase()
    useCase.schedule(on: queue)
  }
}
