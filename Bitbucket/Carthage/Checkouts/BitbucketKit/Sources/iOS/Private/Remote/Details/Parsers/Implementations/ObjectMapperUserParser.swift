//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import ObjectMapper

extension User: Mappable {
  public init?(_ map: Map) {
    self.username = ""
    self.displayName = ""
    self.avatarURL = NSURL()

    guard let urlString = map["links.avatar.href"].currentValue as? String, _ = NSURL(string: urlString) else {
      return nil
    }
  }

  public mutating func mapping(map: Map) {
    username <- map["username"]
    displayName <- map["display_name"]
    avatarURL <- (map["links.avatar.href"], URLTransform())
  }
}

