//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class GetUserURLSessionNetworkOperation: GetUserNetworkOperation, URLSessionNetworkOperation {
  let session: NSURLSession
  private let authenticator: URLRequestAuthenticator

  init(session: NSURLSession, authenticator: URLRequestAuthenticator) {
    self.session = session
    self.authenticator = authenticator
    super.init()
  }

  override func run() {
    let requestBuilder = AuthenticatedBitbucketURLRequestBuilder(
      resourcePath: "user", APIVersion: .two, authenticator: authenticator)
    self.runWithRequestBuilder(requestBuilder)
  }
}

