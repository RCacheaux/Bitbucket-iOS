//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

public struct Repo {
  public internal(set) var name: String
  public internal(set) var description: String
  public internal(set) var owner: User

  public init(name: String, description: String, owner: User) {
    self.name = name
    self.description = description
    self.owner = owner
  }
}
