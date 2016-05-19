//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

public class RefreshAuthenticatedUserOperation: AsyncOperation<User> {
  private let remoteOperation: GetAuthenticatedUserRemoteOperation
  private let dataStore: UserDataStore

  init(remoteOperation: GetAuthenticatedUserRemoteOperation, dataStore: UserDataStore) {
    self.remoteOperation = remoteOperation
    self.dataStore = dataStore
  }

  override func run() {
    remoteOperation.completionBlock = {
      // TODO: Figure out a better way to grab outcome that doesn't require a bunch of mem management boilerplate
      // TODO: How to avoid the pyramid of doom here.
      switch self.remoteOperation.outcome {
      case .success(let user):
        self.dataStore.saveAuthenticatedUser(user) { result in
          switch result {
          case .success:
            self.outcome = .success(user)
          case .error(let error):
            self.outcome = .error(error)
          }
          self.finishedExecutingOperation()
        }
      default:
        self.outcome = self.remoteOperation.outcome
        self.finishedExecutingOperation()
      }
    }
    remoteOperation.start()
  }
}
