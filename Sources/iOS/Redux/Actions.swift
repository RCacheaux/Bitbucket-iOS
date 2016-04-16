//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import ReSwift
import BitbucketKit
import OAuthKit

struct RefreshAccountAction: ReSwift.Action {}

struct GotAccountAction: ReSwift.Action {
  let user: User
}

struct RefreshReposAction: ReSwift.Action {
  let actionID: String
}

struct CancelRefreshReposAction: ReSwift.Action {
  let actionID: String
}

struct GotReposAction: ReSwift.Action {
  let repos: [Repo]
}

struct AuthenticatedAction: ReSwift.Action {
  let user: User
  let account: Account
}
