//
//  OperationResult.swift
//  UseCaseKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation

public enum OperationResult {
  case success
  case error(Error)
  case cancelled
}
