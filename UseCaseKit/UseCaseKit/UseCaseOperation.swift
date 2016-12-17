//
//  UseCaseOperation.swift
//  UseCaseKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation

class UseCaseOperation: AsyncOperation {
  let useCase: UseCase

  init(_ useCase: UseCase) {
    self.useCase = useCase
    super.init()
  }

  override func asyncMain() {
    useCase.start { result in
      var operationResult: OperationResult
      switch result {
      case .success:
        operationResult = .success
      case .error(let error):
        operationResult = .error(error)
      }
      self.finishedExecutingOperation(withResult: operationResult)
    }
  }
}
