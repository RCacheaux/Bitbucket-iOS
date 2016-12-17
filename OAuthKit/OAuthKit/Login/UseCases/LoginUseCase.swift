//
//  LoginUseCase.swift
//  OAuthKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import UIKit
import ReSwift
import UseCaseKit // Is there a way not to couple UseCaseKit to all things? Try mark conformance to UseCase in consuming app.


public class LoginUseCase: UseCase {
  private let presentingViewController: UIViewController
  private let accountStore: Store<AccountState>

  public init(presentingViewController: UIViewController, accountStore: Store<AccountState>) {
    self.presentingViewController = presentingViewController
    self.accountStore = accountStore
  }

  // TODO: Use promise chaining here instead of pyramid of doom.
  public func start(_ onComplete: @escaping (UseCaseResult) -> Void) {
    let webLoginFlow = WebLoginFlow() { credential in
      self.getUser(withCredential: credential, onComplete: { account in
        self.accountStore.dispatch(NewAccountAction(account: account))
        DispatchQueue.main.async {
          self.presentingViewController.dismiss(animated: true, completion: nil)
        }
        onComplete(.success)
      })
    }
    DispatchQueue.main.async {
      self.presentingViewController.present(webLoginFlow, animated: true, completion: nil)
    }
  }

  private func getUser(withCredential credential: Credential, onComplete: @escaping (Account) -> Void) {

    guard let url = URL(string: "https://api.bitbucket.org/2.0/user") else {
      return
    }
    var request = URLRequest(url: url)

    request.setValue("Bearer \(credential.accessToken)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        print("HTTP Error GETing authenitcated user.")
        return
      }
      guard let data = data else {
        print("HTTP GET for authenticated user did not return any data.")
        return
      }

      if let response = String(data: data, encoding: .utf8) {
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
            let account = Account(identifier: identifier, username: username, displayName: displayName, avatarURL: avatarURL, credential: credential)
            onComplete(account)
          }
        }
      } catch {
        // TODO: Handle this situation.
      }
      }.resume()
  }
}


