//
//  SelectTimeView.swift
//  itsBreakTime
//
//  Created by Kazuki Minami on 2023/10/22.
//

// Cool features to have:
// For every one cycle (one focus + one rest), then log the cycle number
// When timer runs out, toggle isActive, isFocused and notify the user
// Dynamic Island!!

import SwiftUI
import UserNotifications

struct Time: Hashable, Equatable {
    var seconds: Int
    var minutes: Int
    
    var totalSeconds: Int {
        get { seconds + minutes * 60 }
        set {
            self.seconds = newValue % 60
            self.minutes = newValue / 60
        }
    }
    
    mutating func decrement() {
        let newTotalSeconds = max(0, self.totalSeconds - 1)  // ensure total seconds doesn't go below 0
        self.totalSeconds = newTotalSeconds
    }
}

struct Presets: Identifiable, Hashable {
    var name: String
    var focusTime: Time
    var restTime: Time
    var id: Int
}

struct SelectTimeView: View {
    
    @State var isZero: Bool
    @State var cycles: Int = 0
    @State var isFocused: Bool = true
    @State var sample: String = "Sample"
    @State var isActive: Bool
    @State var selectedPreset: Presets
    @State var presets: [Presets] = [
        Presets(name: "Classic Pomodoro", focusTime: Time(seconds: 0, minutes: 25), restTime: Time(seconds: 0, minutes: 5), id: 0), //25 minutes focus, 5 mins break
        Presets(name: "Animedoro", focusTime: Time(seconds: 0, minutes: 20), restTime: Time(seconds: 0, minutes: 10), id: 1),
        Presets(name: "Long Pomodoro", focusTime: Time(seconds: 0, minutes: 50), restTime: Time(seconds: 0, minutes: 10), id: 2)
    ]
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Select Preset")) {
                    Picker("Preset: ",selection: $selectedPreset) {
                        ForEach(presets) {preset in
                            Text(preset.name).tag(preset)
                        }
                    }
                    
                    HStack {
                        Picker("", selection: $selectedPreset.focusTime.minutes){
                            ForEach(0..<60, id: \.self) { i in
                                Text("\(i)").tag(i)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .padding(.horizontal)
                        
                        Text("Focus min")
                        
                        Picker("", selection: $selectedPreset.restTime.minutes){
                            ForEach(0..<60, id: \.self) { i in
                                Text("\(i)").tag(i)}}
                        .pickerStyle(WheelPickerStyle())
                        .padding(.horizontal)
                        
                        Text("Rest min")
                    }
                    .padding(.horizontal)
                }
                .disabled(isActive)
                
                Section(header: Text("Time Remaining")){
                    HStack{
                        Text(isFocused ? "Focus: " : "Rest: ")
                        
                        isFocused ? TimerView(timeRemaining: $selectedPreset.focusTime, isActive: $isActive, isZero: $isZero) : TimerView(timeRemaining: $selectedPreset.restTime, isActive: $isActive, isZero: $isZero)
                    }
                }
            }
            
            HStack {
                
                //Start Stop Button
                Button(action: {
                    isActive.toggle()
                }) {
                    Text(isActive ? "Stop" : "Go")
                }
                .foregroundStyle(isActive ? Color.red : Color.green)
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding()
                
                // Skip Button
                Button(action: {
                    isActive = false // pauses the timer
                    
                    isFocused ?
                    (selectedPreset.focusTime = Time(seconds: 0, minutes: 0)) :
                    (selectedPreset.restTime = Time(seconds: 0, minutes: 0))
                    
                    
                    isFocused.toggle() // Changes Focus -> Rest or Rest -> Focus
                    !isFocused ?
                    (selectedPreset.focusTime = presets[selectedPreset.id].focusTime) :
                    (selectedPreset.restTime = presets[selectedPreset.id].restTime)
                    
                }) {
                    Text("Skip")
                }
                .foregroundStyle(isFocused ? Color.mint : Color.green)
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding()
                
                // Request Permissions Button
                Button(action: {
                    requestNotificationPermission()
                }) {
                    Text("Request Permission")
                }
            }

            .navigationBarTitle("Study Timer", displayMode: .large)
        }
        
        
    }
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Handle granted or error here
        }
    }
    
    func checkForZero(){
        if isZero {
            isActive = false
            isFocused.toggle()
        }
        
    }
}

#Preview {
    SelectTimeView(isZero: false, isActive: true, selectedPreset: Presets(name: "Sample", focusTime: Time(seconds: 0, minutes: 19), restTime: Time(seconds: 10, minutes: 45), id: 0))
}
