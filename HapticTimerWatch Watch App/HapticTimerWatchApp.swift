//
//  HapticTimerWatchApp.swift
//  HapticTimerWatch Watch App
//
//  Created by Chase McCarty on 5/18/25.
//

import SwiftUI

@main
struct HapticTimerWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                HapticTestView()
            }
            .tabViewStyle(.page)
        }
    }
}
