//  Copyright © 2016 Atlassian. All rights reserved.

import UIKit
import WebKit

class WebLoginRootView: UIView {
  let webview = WKWebView()
  var onAuthCodeRetrieved: ((String) -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    webview.navigationDelegate = self
    addSubview(webview)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    webview.frame = bounds
  }

  func loadRequest(request: NSURLRequest) -> WKNavigation? {
    return webview.load(request as URLRequest)
  }
}

extension WebLoginRootView: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

    guard let requestURL = navigationAction.request.url else {
      decisionHandler(.allow)
      return
    }

    let host = requestURL.host
    if host == "ios.bitbucket.atlassian.com" {
      let urlComponents = NSURLComponents(url: requestURL, resolvingAgainstBaseURL: false)
      if let items = urlComponents?.queryItems {
        let authCodeQueryItem = items.filter { $0.name == "code" }.first
        if let authCode = authCodeQueryItem?.value {
          print("Got Auth Code: \(authCode)")
          onAuthCodeRetrieved?(authCode)
        }
      }
      decisionHandler(.allow) // or .Cancel
    } else {
      decisionHandler(.allow)
    }

  }

  func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    decisionHandler(.allow)
  }

  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

  }

  func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

  }

  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

  }

  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
  }

  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

  }

//  func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
//    
//    
//  }

  func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {

  }
}
