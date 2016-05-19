//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

class RepoInMemoryDataStore: RepoDataStore {
  private var repos: [Repo] = []
  private let mutationQueue = dispatch_queue_create("com.atlassian.bitbucketkit.inmemoryrepodatastore.mutation", DISPATCH_QUEUE_SERIAL)

  func saveRepos(repos: [Repo], onComplete: (result: Result<Void>)->Void) {
    dispatch_async(mutationQueue) {
      self.repos.appendContentsOf(repos)
      onComplete(result: Result.success())
    }
  }

  func readReposOwnedByUserWithUsername(username: String, onComplete: (result: Result<[Repo]>)->Void) {
    dispatch_async(mutationQueue) {
      let userRepos = self.repos.filter { $0.owner.username == username }
      onComplete(result: Result.success(userRepos))
    }
  }

  func readRepoWithFullName(fullName: String, onComplete: (result: Result<Repo?>)->Void) {
    dispatch_async(mutationQueue) {
      let matchingRepos = self.repos.filter { $0.name == fullName }
      onComplete(result: Result.success(matchingRepos.first))
    }
  }
}
