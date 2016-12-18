//
//  AppDelegate.swift
//  Bitbucket
//
//  Created by Rene Cacheaux on 12/17/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

import UIKit

import OAuthKit
import RxSwift
import ReSwift
import ReSwiftRx
import UseCaseKit
import BitbucketKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let queue = OperationQueue()
  var observable: Observable<AccountState>?

  let store = Store<AppState>(reducer: AppReducer(), state: nil)

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.



    observable = AccountStateObservable.make()
    let _ = observable?.subscribe(onNext: { state in
      if state.accounts.isEmpty {
        return
      }
      print(state.accounts[0])
      let accountObservable = AccountStateObservable.make { state in
        return state.accounts[0]
      }
      let teamsUseCase = RefreshTeamsUseCase(observable: accountObservable, store: self.store)
      teamsUseCase.schedule(on: self.queue)
    })


    let loginUseCase = LoginUseCase(presentingViewController: window!.rootViewController!, accountStore: OAuthKit.store)
    loginUseCase.schedule(on: queue)


    let teamVC = (window!.rootViewController as! UINavigationController).viewControllers[0] as! TeamListViewController
    teamVC.observable = store.makeObservable { state in
      return state.teams
    }

    
    return true
  }


  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

