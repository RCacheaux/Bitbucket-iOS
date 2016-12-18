//
//  Team.swift
//  BitbucketKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation

public struct Team {
  public internal(set) var uuid: String
  public internal(set) var displayName: String
  public internal(set) var username: String
}

import Marshal

extension Team: Unmarshaling {
  public init(object: MarshaledObject) throws {
    self.uuid         = try object.value(for: "uuid")
    self.displayName  = try object.value(for: "display_name")
    self.username     = try object.value(for: "username")
  }
}
