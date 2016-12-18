import PlaygroundSupport

//

import Swinject


protocol ActivityLogger {
  func logMessage(_ message: String)
}

class ConsoleLogger: ActivityLogger {
  func logMessage(_ message: String) {
    print(message)
  }
}

let container = Container()
container.register(ActivityLogger.self) { _ in ConsoleLogger() }

let logger = container.resolve(ActivityLogger.self)!


