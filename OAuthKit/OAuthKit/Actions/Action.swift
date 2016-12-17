//  Copyright © 2016 Atlassian. All rights reserved.

import Foundation

public class Action: Operation {
  private var _executing = false
  private var _finished = false

  override private(set) public var isExecuting: Bool {
    get {
      return _executing
    }
    set {
      willChangeValue(forKey: "isExecuting")
      _executing = newValue
      didChangeValue(forKey: "isExecuting")
    }
  }

  override private(set) public var isFinished: Bool {
    get {
      return _finished
    }
    set {
      willChangeValue(forKey: "isFinished")
      _finished = newValue
      didChangeValue(forKey: "isFinished")
    }
  }

  override public var isAsynchronous: Bool {
    return true
  }

  override public func start() {
    if isCancelled {
      isFinished = true
      return
    }

    isExecuting = true
    autoreleasepool {
      run()
    }
  }

  func run() {
    preconditionFailure("Action.run() abstract method must be overridden.")
  }

  func finishedExecutingAction() {
    isExecuting = false
    isFinished = true
  }
}
