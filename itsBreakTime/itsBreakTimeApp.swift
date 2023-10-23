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
            SelectTimeView(isActive: true, selectedPreset: Presets(name: "Sample", focusTime: Time(seconds: 0, minutes: 19), restTime: Time(seconds: 10, minutes: 45), id: 4))
        }
    }
}
