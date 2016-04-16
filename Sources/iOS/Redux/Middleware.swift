//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import ReSwift
import BitbucketKit

var currentGetAuthenticatedUserAction: GetAuthenticatedUserAction?
var currentGetReposAction: GetUserReposAction?


var currentGetReposActions: [String: GetUserReposAction] = [:]


let networkingMiddleware: Middleware = { dispatch, getState in
  return { next in
    return { action in

      if let networkAction = action as? RefreshAccountAction {
        let getUserAction = GetAuthenticatedUserAction(accountStore: accountStore)
        getUserAction.completionBlock = {
          switch getUserAction.outcome {
          case .Success(let user):
            let newAction = GotAccountAction(user: user)
            dispatch?(newAction)
          default:
            print("x")
          }
        }
        getUserAction.start()
        currentGetAuthenticatedUserAction = getUserAction
      }

      if let networkAction = action as? RefreshReposAction {
        guard let state = getState() as? AppState else {
          return next(action)
        }
        guard let user = state.authenticatedUser else {
          return next(action)
        }
        let getReposAction = GetUserReposAction(user: user, accountStore: accountStore)
        getReposAction.completionBlock = {
          switch getReposAction.outcome {
          case .Success(let repos):
            let newAction = GotReposAction(repos: repos)
            dispatch?(newAction)
          default:
            print("x")
          }
        }
        getReposAction.start()
        currentGetReposAction = getReposAction
        currentGetReposActions[networkAction.actionID] = getReposAction
      }

      if let cancelAction = action as? CancelRefreshReposAction {
        currentGetReposActions[cancelAction.actionID]?.cancel()
      }

      return next(action)
    }
  }
}



