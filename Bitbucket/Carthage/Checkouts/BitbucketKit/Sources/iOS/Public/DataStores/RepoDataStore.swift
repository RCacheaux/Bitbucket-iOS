//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

protocol RepoDataStore {
  func saveRepos(repos: [Repo], onComplete: (result: Result<Void>)->Void)
  func readReposOwnedByUserWithUsername(username: String, onComplete: (result: Result<[Repo]>)->Void)
  func readRepoWithFullName(fullName: String, onComplete: (result: Result<Repo?>)->Void)
}
