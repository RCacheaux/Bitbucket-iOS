//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class BitbucketURLRequestBuilder: URLRequestBuilder {
  let APIVersion: BitbucketAPIVersion
  let host = "api.bitbucket.org"
  let resourcePath: String // TODO: Handle leading and trailing /

  init(resourcePath: String, APIVersion: BitbucketAPIVersion) {
    self.APIVersion = APIVersion
    self.resourcePath = resourcePath
  }

  func buildURLRequest() throws -> NSMutableURLRequest {
    let URLString = "https://\(host)/\(APIVersion.rawValue)/\(resourcePath)"
    if let URL = NSURL(string: URLString) {
      return NSMutableURLRequest(URL: URL)
    } else {
      throw BitbucketKit.Error.invalidURLError
    }
  }

}

enum BitbucketAPIVersion: String {
  case one = "1.0"
  case two = "2.0"
}
