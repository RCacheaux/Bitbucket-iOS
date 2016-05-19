//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

protocol HTTPResponseHandler {

  // Handle is a pretty abstract verb here, think about something more concrete
  func handleResponse(response: NSURLResponse?) throws

}
