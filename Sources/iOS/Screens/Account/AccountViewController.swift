//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import UIKit
import BitbucketKit
import OAuthKit
import ReSwift

class AccountViewController: UITableViewController, StoreSubscriber {
  @IBOutlet weak var displayNameCell: UITableViewCell!
  @IBOutlet weak var usernameCell: UITableViewCell!
  var getUserAction: GetAuthenticatedUserAction?
  var accountStore: AccountStore!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.refreshControl?.addTarget(self, action: "reloadData", forControlEvents: UIControlEvents.ValueChanged)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
//    reloadData()
    store.subscribe(self)
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    store.unsubscribe(self)
  }

  func newState(state: AppState) {
    dispatch_async(dispatch_get_main_queue()) {
      if let user = state.authenticatedUser {
        self.render(user)
      }
      if state.loadingUser {
        self.refreshControl?.beginRefreshing()
      } else {
        self.refreshControl?.endRefreshing()
      }
    }
  }

  func reloadData() {
    store.dispatch(RefreshAccountAction())
    return

    /*
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
    */
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func render(user: User) {
    displayNameCell.textLabel?.text = user.displayName
    usernameCell.detailTextLabel?.text = user.username
  }
}
