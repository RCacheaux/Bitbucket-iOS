//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class DefaultHTTPResponseHandler: HTTPResponseHandler {

  func handleResponse(response: NSURLResponse?) throws {
    guard let response = response else {
      throw BitbucketKit.Error.genericError
    }

    guard let HTTPResponse = response as? NSHTTPURLResponse else {
      throw BitbucketKit.Error.genericError
    }

    guard 200..<300 ~= HTTPResponse.statusCode  else {
      throw BitbucketKit.Error.genericError
    }
  }
}
