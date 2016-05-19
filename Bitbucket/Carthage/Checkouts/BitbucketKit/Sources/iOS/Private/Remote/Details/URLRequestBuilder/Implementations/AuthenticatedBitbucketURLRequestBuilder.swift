//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class AuthenticatedBitbucketURLRequestBuilder: BitbucketURLRequestBuilder {
  let authenticator: URLRequestAuthenticator

  init(resourcePath: String, APIVersion: BitbucketAPIVersion, authenticator: URLRequestAuthenticator) {
    self.authenticator = authenticator
    super.init(resourcePath: resourcePath, APIVersion: APIVersion)
  }

  override func buildURLRequest() throws -> NSMutableURLRequest {
    let request = try super.buildURLRequest()
    return authenticator.authenticateRequest(request)
  }

}
