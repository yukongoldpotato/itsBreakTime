//
//  itsBreakTimeApp.swift
//  itsBreakTime
//
//  Created by Kazuki Minami on 2023/10/22.
//

import SwiftUI

@main
struct itsBreakTimeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(timeRemaining: .constant(Time(seconds: 100, minutes: 100)), isActive: .constant(true))
        }
    }
}
