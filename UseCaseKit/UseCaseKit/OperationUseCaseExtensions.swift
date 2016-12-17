//
//  OperationUseCaseExtensions.swift
//  UseCaseKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation

extension UseCase {
  public func schedule(on queue: OperationQueue) {
    queue.addOperation(UseCaseOperation(self))
  }
}
