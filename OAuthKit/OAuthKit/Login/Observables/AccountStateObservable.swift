//
//  AccountStateObservable.swift
//  OAuthKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation
import ReSwiftRx
import RxSwift
import ReSwift

public let store = Store<AccountState>(reducer: AccountReducer(), state: nil)

private struct AccountReducer: Reducer {
  func handleAction(action: Action, state: AccountState?) -> AccountState {
    var state = state ?? AccountState()
    switch action {
    case let action as NewAccountAction:
      state.accounts.append(action.account)
    default:
      break
    }

    return state
  }
}

public struct AccountStateObservable {
  public static func make() -> Observable<AccountState> {
    return store.makeObservable(nil)
  }
}