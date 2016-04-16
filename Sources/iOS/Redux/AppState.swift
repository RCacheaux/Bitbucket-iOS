//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import ReSwift
import BitbucketKit

struct AppState: StateType, HasAuthenticationState {
  var loadingUser: Bool
  var authenticatedUser: User?
  var authenticatedUserRepos: [Repo]
  var loadingRepos: Bool
  var authenticationState: AuthenticationState
}

extension AppState {
  init() {
    self.loadingUser = false
    self.authenticatedUser = nil
    self.authenticatedUserRepos = []
    self.loadingRepos = false
    self.authenticationState = AuthenticationState(userAuthenticated: false)
  }
}

struct AuthenticationState {
  var userAuthenticated = false
}

protocol HasAuthenticationState {
  var authenticationState: AuthenticationState { get }
}
