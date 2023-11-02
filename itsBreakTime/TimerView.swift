//
//  ContentView.swift
//  itsBreakTime
//
//  Created by Kazuki Minami on 2023/10/22.
//
// Features to include
// Preset When users first open the app, they are invited to set up their breaks schedule. Users can configure their preferred break-length (e.g. 10 minutes) and frequency of their breaks (e.g. every 60 minutes).
//After saving the schedule, users can start or stop the schedule using the app UI.
//When it’s time to take a break, the app triggers a push notification that says “It’s break time!”. The app UI will change to show a countdown timer for any given break.
//When a break is over, the app sends a push notification that says “Your break is over - time to get back to work”.

import SwiftUI

struct TimerView: View {
    
    @Binding var timeRemaining: Time
    @Binding var isActive: Bool
    @Binding var isZero: Bool
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        let formattedTime = String(format: "%02d:%02d", timeRemaining.minutes, timeRemaining.seconds)

        Text(formattedTime)
            .onReceive(timer) { _ in
                if isActive && timeRemaining.totalSeconds > 0 {
                    timeRemaining.decrement() // decrement timeRemaining by 1 every second
                } else if timeRemaining.totalSeconds == 0 {
                    isZero = true 
                    print("TimerView isZero true!")
                }
            }
    }
}


#Preview {
    TimerView(timeRemaining: .constant(Time(seconds: 10, minutes: 2)), isActive: .constant(true), isZero: .constant(false))
}
