//
//  AppDelegate.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/4/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI
import UIKit

/**
    A class called `AppDelegate` starts the app and calls the `createVideosDatabase` function to pull the information from the .json file for starters.
 */
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createPlantsDatabase()
        return true
    }
}
