//
//  AsyncOperation.swift
//  UseCaseKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
  // TODO: Look for comments in OpX

  open func asyncMain() {
    preconditionFailure("Action.run() abstract method must be overridden.")
  }

  fileprivate var _executing = false
  fileprivate var _finished = false
  override private(set) open var isExecuting: Bool {
    get {
      // See if you can create higher order func for this logic below
      var executing: Bool!
      synchronize {
        executing = self._executing
      }
      // assert not nil.
      return executing
    }
    set {
      willChangeValue(forKey: "isExecuting")
      synchronize {
        self._executing = newValue
      }
      didChangeValue(forKey: "isExecuting")
    }
  }
  /// 'true' if operation has finished regardless of success, error, cancellled result; otherwise `false`.
  ///
  /// - Note: Getting and setting is thread safe.
  override private(set) open var isFinished: Bool {
    get {
      var finished: Bool!
      synchronize {
        finished = self._finished
      }
      return finished
    }
    set {
      willChangeValue(forKey: "isFinished")
      synchronize {
        self._finished = newValue
      }
      didChangeValue(forKey: "isFinished")
    }
  }

  private var _result: OperationResult?
  open internal(set) var result: OperationResult? {
    get {
      var result: OperationResult?
      synchronize {
        result = self._result
      }
      // Assert not nil.
      return result
    }
    set {
      synchronize {
        self._result = newValue
      }
    }
  }


  // MARK: Operation Status Flags

  /// Always `true' since this operation is asynchronous.
  override open var isAsynchronous: Bool {
    return true
  }

  // MARK: Initialization

  /// Designated initializer.
  public override init() {
    super.init()
  }

  // MARK: Operation Methods

  /// Starts executing operation. This is a non-blocking method since this operation is asynchronous,
  /// safe to call directy.
  override open func start() {
    if isCancelled {
      isFinished = true
      return
    }

    isExecuting = true
    autoreleasepool { asyncMain() }
  }

  // Cancels executing operation. This will properly trigger KVO for the operation.
  override open func cancel() {
    super.cancel()
    finishedExecutingOperation(withResult: .cancelled)
  }

  /// Stores operation's result and marks operation as not executing and finished.
  ///
  /// Call this method in some sort of async callback/closure/delegate. `asyncMain()` should return immediately,
  /// asynchronous operations **do not** finish until this method is called regardless of whether `asyncMain()` has
  /// returned.
  open func finishedExecutingOperation(withResult result: OperationResult) {
    self.result = result
    self.isExecuting = false
    self.isFinished = true
  }

  /// Serial queue used to synchronize access to stored properties.
  fileprivate let mutationQueue = DispatchQueue(label: "com.atlassian.operationx.operationmutation", attributes: [])
  func synchronize(_ accessData: (Void)->Void) {
    mutationQueue.sync {
      accessData()
    }
  }
  
}
