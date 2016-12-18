//
//  Actions.swift
//  Bitbucket
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation
import ReSwift

public struct UpdateTeams: Action {
  public internal(set) var teams: [Team]
}
