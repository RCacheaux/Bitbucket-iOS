//  Copyright © 2016 Atlassian Pty Ltd. All rights reserved.

import Foundation
import ObjectMapper

extension Repo: Mappable {
  public init?(_ map: Map) {
    self.name = ""
    self.description = ""
    self.owner = User(username: "", displayName: "", avatarURL: NSURL())
  }

  public mutating func mapping(map: Map) {
    name <- map["name"]
    description <- map ["description"]
    owner <- map["owner"]
  }
}

public class ObjectMapperRepoParser: RepoParser {
  func repoFromData(data: NSData, onComplete: (outcome: Outcome<Repo>)->Void) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
      guard let JSONString = String(data: data, encoding: NSUTF8StringEncoding) else {
        onComplete(outcome: Outcome<Repo>.error(BitbucketKit.Error.genericError))
        return
      }
      guard let repo = Mapper<Repo>().map(JSONString) else {
        onComplete(outcome: Outcome<Repo>.error(BitbucketKit.Error.genericError))
        return
      }
      onComplete(outcome: Outcome<Repo>.success(repo))
    }
  }
}
