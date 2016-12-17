import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//

import Foundation
import ReSwiftRx
import RxSwift
import ReSwift

var serverNumbers: [Int] = [1, 2, 3]
var serverStrings: [String] = ["1", "2", "3"]

// State

struct AppState {
  var numbers: [Int] = []
  var strings: [String] = []
}

extension AppState: StateType {}


// Actions

struct RefreshAction: Action {}
struct CreateAction: Action {}


// Reducer

struct AppReducer: Reducer {
  func handleAction(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    switch action {
    case _ as RefreshAction:
      state.numbers = serverNumbers
      state.strings = serverStrings
    case _ as CreateAction:
      state.numbers += [1]
    default:
      break
    }
    return state
  }
}


// Store

let store = Store<AppState>(reducer: AppReducer(), state: nil)


// Usage

let observable = store.makeObservable { state in
  state.numbers
}
observable.subscribe(onNext: { state in
  print("Got new state \(state)")
})

store.dispatch(CreateAction())
store.dispatch(CreateAction())
store.dispatch(RefreshAction())

