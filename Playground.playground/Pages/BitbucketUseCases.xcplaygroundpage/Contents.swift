import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//: Playground - noun: a place where people can play

import Foundation
import BitbucketKit

var str = "Hello, playground"

let queue = OperationQueue()
let refreshUseCase = RefreshTeamsUseCase()

refreshUseCase.schedule(on: queue)


