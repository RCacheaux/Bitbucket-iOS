//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

protocol URLRequestBuilder {

  func buildURLRequest() throws -> NSMutableURLRequest

}
