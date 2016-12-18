//
//  RefreshTeamsUseCase.swift
//  BitbucketKit
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation
import UseCaseKit
import RxSwift
import ReSwift
import OAuthKit

struct UnknownError: Error {}

public class RefreshTeamsUseCase: UseCase {
  let observable: Observable<Account>
  let store: Store<AppState>

  public init(observable: Observable<Account>, store: Store<AppState>) {
    self.observable = observable
    self.store = store
  }

  public func start(_ onComplete: @escaping (UseCaseResult) -> Void) {
    print("Refreshing teams...")
    let _ = observable.subscribe(onNext: { account in
      print("Got Account to call teams API: \(account.credential.accessToken)")
      self.getTeams(autenticateWith: account, onComplete: onComplete)
    })
  }

  func getTeams(autenticateWith account: Account, onComplete: @escaping (UseCaseResult) -> Void) {
    guard let url = URL(string: "https://api.bitbucket.org/2.0/teams?role=member") else {
      onComplete(.error(UnknownError()))
      return
    }
    var request = URLRequest(url: url)
    // Authenticate request
    request.setValue("Bearer \(account.credential.accessToken)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        onComplete(.error(error))
        return
      }
      guard let d = data else {
        onComplete(.error(UnknownError()))
        return
      }
      let json = try! JSONSerialization.jsonObject(with: d, options: []) as! [String: Any]
      let payload = try! TeamsResponsePayload(object: json)
      print("Got teams: \(payload.values)")
      DispatchQueue.main.async {
        self.store.dispatch(UpdateTeams(teams: payload.values))
      }
      onComplete(.success)
    }.resume()
  }
}
