//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class GetUserReposNetworkOperation: AsyncOperation<NSData> {
  let username: String

  init(username: String) {
    self.username = username
    super.init()
  }
}
