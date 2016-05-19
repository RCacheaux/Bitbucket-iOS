//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class GetAuthenticatedUserRemoteOperation: AsyncOperation<User> {
  let networkOperation: GetUserNetworkOperation

  init(networkOperation: GetUserNetworkOperation) {
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
      guard let username = json["username"] as? String,
        displayName = json["display_name"] as? String,
        identifier = json["uuid"] as? String,
        links = json["links"] as? [String: AnyObject],
        avatar = links["avatar"] as? [String: AnyObject],
        avatarURLString = avatar["href"] as? String,
        avatarURL = NSURL(string: avatarURLString) else {
          self.outcome = .error(BitbucketKit.Error.genericError)
          self.finishedExecutingOperation()
          return
      }
      let user = User(username: username, displayName: displayName, avatarURL: avatarURL)
      self.outcome = .success(user)
      self.finishedExecutingOperation()
    } catch {
      self.outcome = .error(BitbucketKit.Error.genericError)
      self.finishedExecutingOperation()
    }
  }
  
}


/*
 
 override func handleHTTPSuccessWithData(data: NSData) {
    do {
      guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
        self.outcome = .error(BitbucketKit.Error.genericError)
        self.finishedExecutingOperation()
        return
      }
      guard let username = json["username"] as? String,
        displayName = json["display_name"] as? String,
        identifier = json["uuid"] as? String,
        links = json["links"] as? [String: AnyObject],
        avatar = links["avatar"] as? [String: AnyObject],
        avatarURLString = avatar["href"] as? String,
        avatarURL = NSURL(string: avatarURLString) else {
          self.outcome = .error(BitbucketKit.Error.genericError)
          self.finishedExecutingOperation()
          return
      }
      let freshAccount = Account(identifier: identifier, username: username, displayName: displayName, avatarURL: avatarURL, credential: authenticatedAccount.credential)
      let user = User(username: freshAccount.username, displayName: freshAccount.displayName, avatarURL: freshAccount.avatarURL)
      self.outcome = .success(user)
      self.finishedExecutingOperation()
    } catch {
      self.outcome = .error(BitbucketKit.Error.genericError)
      self.finishedExecutingOperation()
    }
  }
 */

