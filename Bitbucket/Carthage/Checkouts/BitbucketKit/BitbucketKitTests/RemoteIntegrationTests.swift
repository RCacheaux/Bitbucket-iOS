//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import XCTest
@testable import BitbucketKit
@testable import OAuthKit

/*
class RemoteIntegrationTests: XCTestCase {
  let accountStore = AccountStore()
  let account = Account(identifier: "", username: "", displayName: "", avatarURL: NSURL(), credential: Credential(accessToken: "V6GDfb9U673uODzBn9Htc9R1QDAZorVvdXSShxyVCcHBUCoaGkho602Lr-gRB-89P1e050ZYJH4ZhRt1oQ==", scopes: [], expiresIn: 0, refreshToken: "", tokenType: ""))

  override func setUp() {
    super.setUp()
    accountStore.saveAuthenticatedAccount(account) {
    }
  }

  func testGetRepo() {
    let expectation = expectationWithDescription("getRepoOperation")


    let remoteOperation = GetRepoRemoteOperation(repoFullName: "rcacheaux/drop", accountStore: accountStore, repoParser: ObjectMapperRepoParser())!
    let dataStore = RepoInMemoryDataStore()
    let refreshRepoOperation = RefreshRepoOperation(remoteOperation: remoteOperation, dataStore: dataStore)

    refreshRepoOperation.completionBlock = {
      expectation.fulfill()
    }
    refreshRepoOperation.start()
    waitForExpectationsWithTimeout(100, handler: nil)
//    print(getRepoOperation?.outcome)
    switch refreshRepoOperation.outcome {
    case .success(let repo):
      let _ = repo
      let readExpectation = expectationWithDescription("readRepoOperation")
      dataStore.readRepoWithFullName("Drop") { result in
        switch result {
        case .success(let repo):
          if let repo = repo {
            print("got repo from store: ", repo)
          } else {
            print("repo not found in store")
          }
        default:
          print("error reading from store")
        }
        readExpectation.fulfill()

      }
      waitForExpectationsWithTimeout(100, handler: nil)
      print("hi")
    default:
      print("Bo")
    }
  }
}

*/
