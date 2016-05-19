//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation


class GetRepoNetworkOperation: AsyncOperation<NSData> {
  let repoFullName: String

  init(repoFullName: String) {
    self.repoFullName = repoFullName
  }
}