//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class GetUserReposURLSessionNetworkOperation: GetUserReposNetworkOperation, URLSessionNetworkOperation {
  let session: NSURLSession
  private let authenticator: URLRequestAuthenticator

  init(username: String, session: NSURLSession, authenticator: URLRequestAuthenticator) {
    self.session = session
    self.authenticator = authenticator
    super.init(username: username)
  }

  override func run() {
    let requestBuilder = AuthenticatedBitbucketURLRequestBuilder(
      resourcePath: "repositories/\(username)", APIVersion: .two, authenticator: authenticator)
    self.runWithRequestBuilder(requestBuilder)
  }
}
