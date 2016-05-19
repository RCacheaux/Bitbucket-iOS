//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class GetRepoURLSessionNetworkOperation: GetRepoNetworkOperation, URLSessionNetworkOperation {
  let session: NSURLSession
  private let authenticator: URLRequestAuthenticator

  init(repoFullName: String, session: NSURLSession, authenticator: URLRequestAuthenticator) {
    self.session = session
    self.authenticator = authenticator
    super.init(repoFullName: repoFullName)
  }

  override func run() {
    let requestBuilder = AuthenticatedBitbucketURLRequestBuilder(
      resourcePath: "repositories/\(repoFullName)", APIVersion: .two, authenticator: authenticator)
    self.runWithRequestBuilder(requestBuilder)
  }
}
