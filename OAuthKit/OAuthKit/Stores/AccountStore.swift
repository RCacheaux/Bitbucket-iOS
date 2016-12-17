//  Copyright © 2016 Atlassian. All rights reserved.

import Foundation

import ReSwift

public struct AccountState: StateType {
  public internal(set) var accounts: [Account] = []
}
