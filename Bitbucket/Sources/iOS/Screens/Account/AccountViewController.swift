//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import UIKit
import BitbucketKit
import OAuthKit

class AccountViewController: UITableViewController {
  @IBOutlet weak var displayNameCell: UITableViewCell!
  @IBOutlet weak var usernameCell: UITableViewCell!
  var getUserAction: GetAuthenticatedUserAction?
  var accountStore: AccountStore!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.refreshControl?.addTarget(self, action: #selector(AccountViewController.reloadData), forControlEvents: UIControlEvents.ValueChanged)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    reloadData()
  }

  func reloadData() {
    self.refreshControl?.beginRefreshing()
    let getUserAction = GetAuthenticatedUserAction(accountStore: accountStore)
    getUserAction.completionBlock = {
      switch getUserAction.outcome {
      case .Success(let user):
        dispatch_async(dispatch_get_main_queue()) {
          self.render(user)
          self.refreshControl?.endRefreshing()
        }
      default:
        print("Something went wrong trying to get user's account.")
      }
    }
    getUserAction.start()
    self.getUserAction = getUserAction
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func render(user: User) {
    displayNameCell.textLabel?.text = user.displayName
    usernameCell.detailTextLabel?.text = user.username
  }
}
