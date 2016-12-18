//
//  APIResponsePayload.swift
//  BitbucketKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation

public struct TeamsResponsePayload {
  var pageLength: Int
  var page: Int
  var size: Int
  var values: [Team]
}

import Marshal

extension TeamsResponsePayload: Unmarshaling {
  public init(object: MarshaledObject) throws {
    self.pageLength   = try object.value(for: "pagelen")
    self.page         = try object.value(for: "page")
    self.size         = try object.value(for: "size")
    self.values       = try object.value(for: "values")
  }
}
