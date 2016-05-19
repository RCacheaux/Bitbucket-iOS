//  Copyright © 2016 Atlassian. All rights reserved.

import Foundation

public enum Outcome<T> {
  case success(T)
  case error(ErrorType)
  case cancelled
}
