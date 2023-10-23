//
//  SelectTimeView.swift
//  itsBreakTime
//
//  Created by Kazuki Minami on 2023/10/22.
//

import SwiftUI

struct Time: Hashable {
    var seconds: Int
    var minutes: Int
    
    var totalSeconds: Int {
        get { seconds + minutes * 60 }
        set {
            self.seconds = newValue % 60
            self.minutes = newValue / 60
        }
    }
    
//    init(totalSeconds: Int) {
//        self.seconds = totalSeconds % 60
//        self.minutes = totalSeconds / 60
//    }
    
    mutating func decrement() {
        let newTotalSeconds = max(0, self.totalSeconds - 1)  // ensure total seconds doesn't go below 0
        self.totalSeconds = newTotalSeconds
    }
}

struct Presets: Identifiable, Hashable {
    var name: String
    var focusTime: Time
    var restTime: Time
    var id: String {name}
    
}

struct SelectTimeView: View {
    
    @State var isFocused: Bool = true
    @State var sample: String = "Sample"
    @State var isActive: Bool
    @State var selectedPreset: Presets
    @State var presets: [Presets] = [
        Presets(name: "Classic Pomodoro", focusTime: Time(seconds: 0, minutes: 25), restTime: Time(seconds: 0, minutes: 5)), //25 minutes focus, 5 mins break
        Presets(name: "Animedoro", focusTime: Time(seconds: 0, minutes: 20), restTime: Time(seconds: 0, minutes: 10)),
        Presets(name: "Long Pomodoro", focusTime: Time(seconds: 0, minutes: 50), restTime: Time(seconds: 0, minutes: 10))
    ]
    
    var body: some View {
        Form {
            
            Section(header: Text("Select Preset")) {
                Picker("Preset: ",selection: $selectedPreset) {
                    ForEach(presets) {preset in
                        Text(preset.name).tag(preset)
                    }
                    .onChange(of: selectedPreset) {
                        print(selectedPreset.focusTime)
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
                    Text(isFocused ? "Rest: " : "Focus: ")
                    ContentView(timeRemaining: $selectedPreset.focusTime, isActive: $isActive)
                }
            }
        }
        
        HStack {
            Button(action: {
                isActive.toggle()
            }) {
                Text(isActive ? "Stop" : "Go")
            }
            .foregroundStyle(isActive ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding()
            
            Button(action: {
                isFocused.toggle()
            }) {
                Text("Skip")
            }
            .foregroundStyle(isFocused ? Color.mint : Color.green)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding()
        }
    }
}

#Preview {
    SelectTimeView(isActive: true, selectedPreset: Presets(name: "Sample", focusTime: Time(seconds: 0, minutes: 19), restTime: Time(seconds: 10, minutes: 45)))
}
