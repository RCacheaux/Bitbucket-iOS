//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class URLRequestBearerTokenAuthenticator: URLRequestAuthenticator {
  private let token: String

  init(token: String) {
    self.token = token
  }

  func authenticateRequest(request: NSMutableURLRequest) -> NSMutableURLRequest {
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
  }
}
