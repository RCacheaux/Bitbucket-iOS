//  Copyright © 2016 Atlassian. All rights reserved.

import UIKit

public class LoginAction: Action {
  let presentingViewController: UIViewController
  public internal(set) var credential: Credential?
  public internal(set) var account: Account?
  let accountStore: AccountStore

  public init(presentingViewController: UIViewController, accountStore: AccountStore) {
    self.presentingViewController = presentingViewController
    self.accountStore = accountStore
    super.init()
  }

  override func run() {
    let webLoginFlow = WebLoginFlow(onComplete: {
      self.credential = $0
      self.getUser(onComplete: { account in
        self.account = account
        DispatchQueue.main.async {
          self.presentingViewController.dismiss(animated: true, completion: nil)
        }
        self.finishedExecutingAction()
      })
    })
    DispatchQueue.main.async {
      self.presentingViewController.present(webLoginFlow, animated: true, completion: nil)
    }
  }


  func getUser(onComplete onComplete: @escaping (Account) -> Void) {


    guard let url = NSURL(string: "https://api.bitbucket.org/2.0/user") else {
      return
    }
    let request = NSMutableURLRequest(url: url as URL)


    request.setValue("Bearer \(self.credential!.accessToken)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
      guard error == nil else {
        print("HTTP Error GETing authenitcated user.")
        return
      }
      guard let data = data else {
        print("HTTP GET for authenticated user did not return any data.")
        return
      }

      if let response = String(data: data, encoding: String.Encoding.utf8) {
        print("Response: \(response)")
      } else {
        print("Could not convert response data into UTF8 String from authenticated user GET.")
      }

      do {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let json = json as? [String: AnyObject] {
          if
            let username = json["username"] as? String,
            let displayName = json["display_name"] as? String,
            let identifier = json["uuid"] as? String,
            let links = json["links"] as? [String: AnyObject],
            let avatar = links["avatar"] as? [String: AnyObject],
            let avatarURLString = avatar["href"] as? String,
            let avatarURL = NSURL(string: avatarURLString) {
              let account = Account(identifier: identifier, username: username, displayName: displayName, avatarURL: avatarURL, credential: self.credential!)
              self.accountStore.saveAuthenticatedAccount(account: account) {
                onComplete(account)
              }
          }
        }
      } catch {
        // TODO: Handle this situation.
      }
    }.resume()

  }

}
