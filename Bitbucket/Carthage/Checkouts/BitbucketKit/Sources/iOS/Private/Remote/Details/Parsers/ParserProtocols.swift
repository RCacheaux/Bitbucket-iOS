//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

protocol RepoParser {
  func repoFromData(data: NSData, onComplete: (outcome: Outcome<Repo>)->Void)
}

protocol UserParser {
  func userFromData(data: NSData, onComplete: (outcome: Outcome<User>)->Void)
}