//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

protocol URLSessionNetworkOperation: class {
  var outcome: Outcome<NSData> { get set }
  var session: NSURLSession { get }

  func runWithRequestBuilder(requestBuilder: URLRequestBuilder)
  func finishedExecutingOperation()
}

extension URLSessionNetworkOperation {
  func runWithRequestBuilder(requestBuilder: URLRequestBuilder) {
    let request = try! requestBuilder.buildURLRequest()

    session.dataTaskWithRequest(request) { data, response, error in
      guard error == nil else {
        print("HTTP Error GETing user repos.")
        self.outcome = .error(BitbucketKit.Error.genericError)
        self.finishedExecutingOperation()
        return
      }

      let responseHandler = DefaultHTTPResponseHandler()
      try! responseHandler.handleResponse(response)

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

      self.outcome = .success(data)
      self.finishedExecutingOperation()
      
      }.resume()
  }
}
