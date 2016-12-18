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

public struct AccountReducer: Reducer {

  public init() {}

  public func handleAction(action: Action, state: AccountState?) -> AccountState {
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
  public static func make<SelectedState>(_ selector: ((AccountState) -> SelectedState)? = nil) -> Observable<SelectedState> {
    return store.makeObservable(selector)
  }
}


