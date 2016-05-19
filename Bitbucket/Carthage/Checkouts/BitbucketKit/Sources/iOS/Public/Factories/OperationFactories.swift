//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import Swinject
import OAuthKit

private let container: Container = {
  let c = Container()
  c.register(AccountStore.self) { _ in return AccountStore() }.inObjectScope(.Container)
  c.register(UserDataStore.self) { _ in return UserInMemoryDataStore() }.inObjectScope(.Container)
  c.register(RepoDataStore.self) { _ in return RepoInMemoryDataStore() }.inObjectScope(.Container)

  c.register(URLRequestAuthenticator.self) { r in
    let accountStore = r.resolve(AccountStore.self)
    var token = ""
    let dispatchGroup = dispatch_group_create()
    dispatch_group_enter(dispatchGroup)
    accountStore!.getAuthenticatedAccount { account in
      token = account!.credential.accessToken
      dispatch_group_leave(dispatchGroup)
    }
    dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER)
    return URLRequestBearerTokenAuthenticator(token: token)
  }

  // Refresh Authenticated User
  c.register(GetUserNetworkOperation.self) { r in
    return GetUserURLSessionNetworkOperation(session:NSURLSession.sharedSession(),
                                             authenticator: r.resolve(URLRequestAuthenticator.self))
  }
  c.register(GetAuthenticatedUserRemoteOperation.self) { r in
    return GetAuthenticatedUserRemoteOperation(networkOperation: r.resolve(GetUserNetworkOperation.self))
  }
  c.register(RefreshAuthenticatedUserOperation.self) { r in
    return RefreshAuthenticatedUserOperation(remoteOperation: r.resolve(GetAuthenticatedUserRemoteOperation.self),
                                             dataStore: r.resolve(UserDataStore.self))
  }

  // Refresh Repo
  c.register(RepoParser.self) { r in
    return ObjectMapperRepoParser()
  }
  c.register(GetRepoNetworkOperation.self) { r, repoFullName in
    return GetRepoURLSessionNetworkOperation(repoFullName: repoFullName,
                                             session: NSURLSession.sharedSession(),
                                             authenticator: r.resolve(URLRequestAuthenticator.self))
  }
  c.register(GetRepoRemoteOperation.self) { (r: ResolverType, repoFullName: String) in
    return GetRepoRemoteOperation(networkOperation:r.resolve(GetRepoNetworkOperation.self, argument: repoFullName),
                                  parser: r.resolve(RepoParser.self))
  }
  c.register(RefreshRepoOperation.self) { (r: ResolverType, repoFullName: String) in
    return RefreshRepoOperation(remoteOperation: r.resolve(GetRepoRemoteOperation.self, argument: repoFullName),
                                dataStore: r.resolve(RepoDataStore.self))
  }

  // Refresh User Repos
  c.register(GetUserReposNetworkOperation.self) { r, username in
    return GetUserReposURLSessionNetworkOperation(username: username,
                                                  session: NSURLSession.sharedSession(),
                                                  authenticator: r.resolve(URLRequestAuthenticator.self))
  }
  c.register(GetUserReposRemoteOperation.self) { (r:ResolverType, username: String) in
    return GetUserReposRemoteOperation(networkOperation: r.resolve(GetUserReposNetworkOperation.self, argument: username))
  }
  c.register(RefreshUserReposOperation.self) { (r:ResolverType, username: String) in
    return RefreshUserReposOperation(remoteOperation: r.resolve(GetUserReposRemoteOperation.self, argument: username),
                                     dataStore: r.resolve(RepoDataStore.self))
  }

  return c
}()

extension Resolvable {
  public func resolve<Service>(serviceType: Service.Type) -> Service {
    return self.resolve(serviceType)!
  }

  public func resolve<Service, Arg1>(serviceType: Service.Type, argument: Arg1) -> Service {
    return self.resolve(serviceType, argument: argument)!
  }
}

public func makeRefreshAuthenticatedUserOperation() -> RefreshAuthenticatedUserOperation {
  return container.resolve(RefreshAuthenticatedUserOperation.self)
}

public func makeRefreshRepoOperation(repoFullName: String) -> RefreshRepoOperation {
  return container.resolve(RefreshRepoOperation.self, argument: repoFullName)
}

public func makeRefreshUserReposOperation(username: String) -> RefreshUserReposOperation {
  return container.resolve(RefreshUserReposOperation.self, argument: username)
}

public func getAccountStore() -> AccountStore {
  return container.resolve(AccountStore.self)
}

