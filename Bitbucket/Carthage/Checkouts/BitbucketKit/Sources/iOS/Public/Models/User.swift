//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

public struct User {
  public internal(set) var username: String
  public internal(set) var displayName: String
  public internal(set) var avatarURL: NSURL

  public init(username: String, displayName: String, avatarURL: NSURL) {
    self.username = username
    self.displayName = displayName
    self.avatarURL = avatarURL
  }
}
