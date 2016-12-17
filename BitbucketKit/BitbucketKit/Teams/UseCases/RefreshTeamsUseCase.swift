//
//  RefreshTeamsUseCase.swift
//  BitbucketKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation
import UseCaseKit

public class RefreshTeamsUseCase: UseCase {

  public init() {

  }

  public func start(_ onComplete: @escaping (UseCaseResult) -> Void) {
    print("Refreshing teams...")
    DispatchQueue.global().async {
      onComplete(.success)
    }
  }
}
