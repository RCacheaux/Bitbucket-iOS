//  Copyright © 2016 Atlassian. All rights reserved.

import Foundation

public class AccountStore {
  private var store: [Account] = []
  private let mutationQueue = DispatchQueue(label: "com.atlassian.oauthkit.accountStore.mutation")

  public init() {}

  func saveAuthenticatedAccount(account: Account, onComplete: @escaping (Void) -> Void) {
    mutationQueue.async {
      self.unsafeSaveAuthenticatedAccount(account: account)
      DispatchQueue.global(qos: .background).async {
        onComplete()
      }
    }
  }

  private func unsafeSaveAuthenticatedAccount(account: Account) {
    store = [account]
  }

  public func getAuthenticatedAccount(onComplete: @escaping (Account?) -> Void) {
    mutationQueue.async {
      self.unsafeGetAuthenticatedAccount(onComplete: onComplete)
    }
  }

  private func unsafeGetAuthenticatedAccount(onComplete: @escaping (Account?) -> Void) {
    if let account = store.first {
      DispatchQueue.global(qos: .background).async {
        onComplete(account)
      }
    } else {
      DispatchQueue.global(qos: .background).async {
        onComplete(nil)
      }
    }
  }

  public func authenticateURLRequest(request: NSMutableURLRequest, onComplete: @escaping (NSMutableURLRequest?) -> Void) {
    mutationQueue.async {
      self.unsafeAuthenticateURLRequest(request: request, onComplete: onComplete)
    }
  }

  private func unsafeAuthenticateURLRequest(request: NSMutableURLRequest, onComplete: @escaping (NSMutableURLRequest?) -> Void) {
    if let account = store.first {
      DispatchQueue.global(qos: .background).async {
        request.setValue("Bearer \(account.credential.accessToken)", forHTTPHeaderField: "Authorization")
        onComplete(request)
      }
    } else {
      DispatchQueue.global(qos: .background).async {
        onComplete(nil)
      }
    }
  }
}
