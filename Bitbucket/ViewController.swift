//  Copyright © 2016 Atlassian. All rights reserved.

import UIKit
import OAuthKit
import BitbucketKit

let accountStore = AccountStore()

class ViewController: UIViewController {
  var loginAction: LoginAction?
  var getReposAction: GetUserReposAction?
  var getUserAction: GetAuthenticatedUserAction?
  var appTabBarController: UITabBarController!
  var accountViewController: AccountViewController!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    guard let _ = loginAction else {
      loginAction = LoginAction(presentingViewController: self, accountStore: accountStore)
      loginAction?.completionBlock = {




        if let credential = self.loginAction?.credential {
          print("Aww yea, got credential! \n\(credential)")
        }
        if let account = self.loginAction?.account {
          let user = User(username: account.username, displayName: account.displayName, avatarURL: account.avatarURL)
          store.dispatch(AuthenticatedAction(user: user, account: account))

          print("Aww yea, got account! \n\(account)")
        }
        accountStore.getAuthenticatedAccount() { account in
          if let account = account {
            print("Aww yea, got account from account store!\n\(account)")
          }
        }

        self.getRepositories()
      }
      loginAction?.start()
      return
    }


  }

  func getRepositories() {
    let getUserAction = GetAuthenticatedUserAction(accountStore: accountStore)
    getUserAction.completionBlock = {
      switch getUserAction.outcome {
      case .Success(let user):
        let getReposAction = GetUserReposAction(user: user, accountStore: accountStore)
        getReposAction.completionBlock = {
          switch getReposAction.outcome {
          case .Success(let repos):
            print("Awww yea, got repos:\n\(repos)")
          default:
            return
          }
        }
        getReposAction.start()
        self.getReposAction = getReposAction
      default:
        return
      }
    }
    getUserAction.start()
    self.getUserAction = getUserAction

    //    self.accountStore.getAuthenticatedAccount { account in
    //      guard let account = account else {
    //        return
    //      }
    //
    //      guard let url = NSURL(string: "https://api.bitbucket.org/2.0/repositories/\(account.username)") else {
    //        return
    //      }
    //
    //      let request = NSMutableURLRequest(URL: url)
    //      self.accountStore.authenticateURLRequest(request) { request in
    //        guard let request = request else {
    //          return
    //        }
    //
    //        NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
    //          guard error == nil else {
    //            print("HTTP Error GETing repos.")
    //            return
    //          }
    //          guard let data = data else {
    //            print("HTTP GET for repos did not return any data.")
    //            return
    //          }
    //
    //          if let response = String(data: data, encoding: NSUTF8StringEncoding) {
    //            print("Response: \(response)")
    //          } else {
    //            print("Could not convert response data into UTF8 String from repos GET.")
    //          }
    //          }.resume()
    //      }
    //
    //    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let appTabBarController = segue.destinationViewController as? UITabBarController {
      self.appTabBarController = appTabBarController
      if let accountNavController = self.appTabBarController.viewControllers?[1] as? UINavigationController {
        if let accountViewController = accountNavController.viewControllers[0] as? AccountViewController {
          self.accountViewController = accountViewController
          self.accountViewController.accountStore = accountStore
        }
      }
      if let repoListNavController = self.appTabBarController.viewControllers?[0] as? UINavigationController {
        if let repoListViewController = repoListNavController.viewControllers[0] as? RepoListViewController {
          repoListViewController.accountStore = accountStore
        }
      }
    }
  }
}

