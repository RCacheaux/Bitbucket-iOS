//
//  AppReducer.swift
//  Bitbucket
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation
import ReSwift

public struct AppReducer: Reducer {

  public init() {}

  public func handleAction(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    switch action {
    case let action as UpdateTeams:
      state.teams = action.teams
    default:
      break
    }
    return state
  }

}
