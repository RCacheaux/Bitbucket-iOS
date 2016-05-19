//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

enum Result<T> {
  case success(T)
  case error(ErrorType)
}
