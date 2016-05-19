//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import OAuthKit

class GetUserReposRemoteOperation: AsyncOperation<[Repo]> {
  let networkOperation: GetUserReposNetworkOperation

  init(networkOperation: GetUserReposNetworkOperation) {
    self.networkOperation = networkOperation
    super.init()
  }

  override func run() {
    networkOperation.completionBlock = {
      switch self.networkOperation.outcome {
      case .success(let data):
        self.handleHTTPSuccessWithData(data)
      case .cancelled:
        self.outcome = .cancelled
        self.finishedExecutingOperation()
      case .error(let error):
        self.outcome = .error(error)
        self.finishedExecutingOperation()
      }
    }
    networkOperation.start()
  }

  func handleHTTPSuccessWithData(data: NSData) {
    do {
      guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
        self.outcome = .error(BitbucketKit.Error.genericError)
        self.finishedExecutingOperation()
        return
      }
      guard let values = json["values"] as? [[String: AnyObject]] else {
        self.outcome = .error(BitbucketKit.Error.genericError)
        self.finishedExecutingOperation()
        return
      }
      let repos = values.map { (json: [String: AnyObject]) -> Repo in
        guard let name = json["name"] as? String,
          description = json["description"] as? String,
          ownerJSON = json["owner"] as? [String: AnyObject] else {
            return Repo(name: "", description: "", owner: User(username: "", displayName: "", avatarURL: NSURL()))
        }
        guard let username = ownerJSON["username"] as? String,
          displayName = ownerJSON["display_name"] as? String,
          links = ownerJSON["links"] as? [String: AnyObject],
          avatar = links["avatar"] as? [String: AnyObject],
          avatarHRef = avatar["href"] as? String,
          avatarURL = NSURL(string: avatarHRef) else {
            return Repo(name: "", description: "", owner: User(username: "", displayName: "", avatarURL: NSURL()))
        }
        let owner = User(username: username, displayName: displayName, avatarURL: avatarURL)
        return Repo(name: name, description: description, owner: owner)
      }
      self.outcome = .success(repos)
      self.finishedExecutingOperation()
    } catch {
      self.outcome = .error(BitbucketKit.Error.genericError)
      self.finishedExecutingOperation()
    }
  }
}
