//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import OAuthKit

class AuthenticatedRemoteOperation<T>: AsyncOperation<T> {
  private let authenticator: URLRequestAuthenticator
  private let HTTPRequestURL: NSURL

  init?(authenticator: URLRequestAuthenticator, HTTPRequestURLString: String) {
    self.authenticator = authenticator
    guard let url = NSURL(string: HTTPRequestURLString) else {
      return nil
    }
    self.HTTPRequestURL = url

    super.init()
  }

  override func run() {
    var request = NSMutableURLRequest(URL: HTTPRequestURL)
    request = authenticator.authenticateRequest(request)
    runWithAuthenticatedRequest(request)
  }

  private func runWithAuthenticatedRequest(request: NSMutableURLRequest) {
    NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
      guard error == nil else {
        print("HTTP Error GETing user repos.")
        self.outcome = .error(BitbucketKit.Error.genericError)
        self.finishedExecutingOperation()
        return
      }

      guard let HTTPResponse = response as? NSHTTPURLResponse else {
        self.outcome = .error(BitbucketKit.Error.genericError)
        self.finishedExecutingOperation()
        return
      }

      guard 200..<300 ~= HTTPResponse.statusCode  else {
        self.outcome = .error(BitbucketKit.Error.genericError)
        self.finishedExecutingOperation()
        return
      }

      guard let data = data else {
        print("HTTP GET for user repos did not return any data.")
        self.outcome = .error(BitbucketKit.Error.genericError)
        self.finishedExecutingOperation()
        return
      }
      if let response = String(data: data, encoding: NSUTF8StringEncoding) {
        print("Response: \(response)")
      } else {
        print("Could not convert response data into UTF8 String from user repos GET.")
      }
      self.handleHTTPSuccessWithData(data)
    }.resume()
  }

  internal func handleHTTPSuccessWithData(data: NSData) {

  }
  
  
  
}


