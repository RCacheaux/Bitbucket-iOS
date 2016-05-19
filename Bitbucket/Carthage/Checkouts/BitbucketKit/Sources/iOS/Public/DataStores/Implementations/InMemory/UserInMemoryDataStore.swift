//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class UserInMemoryDataStore: UserDataStore {
  private var authenticatedUser: User?
  private let mutationQueue = dispatch_queue_create("com.atlassian.bitbucketkit.userinmemorydatastore.mutation", DISPATCH_QUEUE_SERIAL)

  func saveAuthenticatedUser(user: User, onComplete: (result: Result<Void>)->Void) {
    dispatch_async(mutationQueue) {
      self.authenticatedUser = user
      onComplete(result: Result.success())
    }
  }

  func readAuthenticatedUser(onComplete: (result: Result<User?>)->Void) {
    dispatch_async(mutationQueue) {
      onComplete(result: Result.success(self.authenticatedUser))
    }
  }
}
