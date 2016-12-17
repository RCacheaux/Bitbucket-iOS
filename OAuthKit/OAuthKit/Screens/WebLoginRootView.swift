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
  func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

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

  func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
    decisionHandler(.allow)
  }

  func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

  }

  func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

  }

  func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {

  }

  func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
    
  }

  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    
  }

  func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {

  }

//  func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
//    
//    
//  }

  func webViewWebContentProcessDidTerminate(webView: WKWebView) {

  }
}
