//
//  StoreSubscriptionExtensions.swift
//  ReSwiftRx
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift

extension Store {
  public func makeObservable<SelectedState>(_ selector: ((State) -> SelectedState)?) -> Observable<SelectedState> {
    return Observable.create(self.makeSubscribeClosure(selector))
  }

  private func makeSubscribeClosure<SelectedState>(_ selector: ((State) -> SelectedState)?) ->
    ((AnyObserver<SelectedState>) -> Disposable) {
      return { [weak self] observer in
        guard let strongSelf = self else { // TODO: should the observable emmit an error here?
          return Disposables.create()
        }
        return strongSelf.subscribe(observer, selector: selector)
      }
  }

  private func subscribe<SelectedState>(_ rxObserver: AnyObserver<SelectedState>,
                         selector: ((State) -> SelectedState)?) -> Cancelable {
    let subscriber = RxStoreSubscriber<SelectedState>(rxObserver)
    subscribe(subscriber, selector: selector)
    return makeDisposable(subscriber)
  }


  private func makeDisposable(_ subscriber: AnyStoreSubscriber) -> Cancelable {
    return Disposables.create {
      self.unsubscribe(subscriber)
    }
  }
}
