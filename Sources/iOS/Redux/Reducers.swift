//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import ReSwift

struct AppReducer: Reducer {

  // What if the action results in no state change? Is there a way to prevent newState() from being called on all subscribers?
  func handleAction(action: Action, state: AppState?) -> AppState {
    var newState = state ?? AppState()

    switch action {
    case let action as AuthenticatedAction:
      newState.authenticationState.userAuthenticated = true
      newState.authenticatedUser = action.user
    case _ as RefreshAccountAction:
      newState.loadingUser = true
    case let action as GotAccountAction:
      newState.authenticatedUser = action.user
      newState.loadingUser = false
    case _ as RefreshReposAction:
      newState.loadingRepos = true
    case _ as CancelRefreshReposAction:
      newState.loadingRepos = false
    case let action as GotReposAction:
      newState.authenticatedUserRepos = action.repos
      newState.loadingRepos = false
    default:
      break
    }

    return newState
  }
}

