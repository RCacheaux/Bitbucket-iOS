//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation

protocol UserDataStore {
  func saveAuthenticatedUser(user: User, onComplete: (result: Result<Void>)->Void)
  func readAuthenticatedUser(onComplete: (result: Result<User?>)->Void)
}
