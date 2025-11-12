//
//  SettingsView.swift
//  HapticTimerWatch Watch App
//
//  Created by Chase McCarty on 11/10/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("hapticIntervalMinutes") private var hapticIntervalMinutes: Int = 5
    @State private var selectedInterval: Int = 5
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Haptic Interval")
                .font(.headline)
                .padding(.top, 8)
            
            Picker("Minutes", selection: $selectedInterval) {
                ForEach(1...60, id: \.self) { minutes in
                    Text("\(minutes)").tag(minutes)
                }
            }
            .labelsHidden()
            .frame(height: 80)
            
            Text("\(selectedInterval) min")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Button(action: {
                hapticIntervalMinutes = selectedInterval
            }) {
                Text("Apply")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .onAppear {
            selectedInterval = hapticIntervalMinutes
        }
    }
}

#Preview {
    SettingsView()
}

