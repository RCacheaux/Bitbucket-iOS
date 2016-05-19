//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import OAuthKit

class GetRepoRemoteOperation: AsyncOperation<Repo> {
  let networkOperation: GetRepoNetworkOperation
  let parser: RepoParser

  init(networkOperation: GetRepoNetworkOperation, parser: RepoParser) {
    self.networkOperation = networkOperation
    self.parser = parser
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
    parser.repoFromData(data) { outcome in
      self.outcome = outcome
      self.finishedExecutingOperation()
    }
  }
}
