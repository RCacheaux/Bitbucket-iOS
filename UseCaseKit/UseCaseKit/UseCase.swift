//
//  UseCase.swift
//  UseCaseKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation

public protocol UseCase {
  func start(_ onComplete: @escaping (UseCaseResult) -> Void)
}
