//
//  RxStoreSubscriber.swift
//  ReSwiftRx
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift

class RxStoreSubscriber<StateType>: StoreSubscriber {
  let rxObserver: AnyObserver<StateType>

  init(_ rxObserver: AnyObserver<StateType>) {
    self.rxObserver = rxObserver
  }

  func newState(state: StateType) {
    rxObserver.on(.next(state))
  }
}
