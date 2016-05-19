//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

protocol URLRequestAuthenticator {

  func authenticateRequest(request: NSMutableURLRequest) -> NSMutableURLRequest

}
