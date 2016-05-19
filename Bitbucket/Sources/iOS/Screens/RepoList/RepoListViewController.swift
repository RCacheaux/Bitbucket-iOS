//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import UIKit
import BitbucketKit
import OAuthKit

class RepoListViewController: UITableViewController {
  var accountStore: AccountStore!
  var getReposAction: RefreshUserReposOperation?
  var repos: [Repo] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    refreshControl?.addTarget(self, action: #selector(RepoListViewController.reloadData), forControlEvents: UIControlEvents.ValueChanged)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func reloadData() {
    refreshControl?.beginRefreshing()
    accountStore.getAuthenticatedAccount { account in
      guard let account = account else {
        print("Something went wrong retrieving authenticated account from account store before GETing authenticated user's repos.")
        self.endRefreshingOnMain()
        return
      }
      let user = User(username: account.username, displayName: account.displayName, avatarURL: account.avatarURL)
      let getReposAction = makeRefreshUserReposOperation(user.username)
      getReposAction.completionBlock = {
        switch getReposAction.outcome {
        case .success(let repos):
          dispatch_async(dispatch_get_main_queue()) {
            self.repos = repos
            self.tableView.reloadData()
          }
        default:
          print("Something went wrong GETing repos for authenticated user.")
        }
        self.endRefreshingOnMain()
      }
      getReposAction.start()
      self.getReposAction = getReposAction
    }
  }

  func endRefreshingOnMain() {
    dispatch_async(dispatch_get_main_queue()) {
      self.refreshControl?.endRefreshing()
    }
  }

  // MARK: - Table view data source

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repos.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("RepoCell", forIndexPath: indexPath)
    let repo = repos[indexPath.row]
    cell.textLabel?.text = repo.name
    return cell
  }

  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the specified item to be editable.
  return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
  // Delete the row from the data source
  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  } else if editingStyle == .Insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
  return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
