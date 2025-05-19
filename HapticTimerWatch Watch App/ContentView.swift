//
//  ContentView.swift
//  HapticTimerWatch Watch App
//
//  Created by Chase McCarty on 5/18/25.
//

import SwiftUI
import WatchKit
import HapticTimer

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text(timeString(from: viewModel.elapsedTime))
                .font(.system(size: 36, weight: .medium, design: .monospaced))
                .padding(.top, 16)
            
            Button(action: {
                if viewModel.isRunning {
                    viewModel.stop()
                } else {
                    viewModel.start()
                }
            }) {
                Text(viewModel.isRunning ? "Stop" : "Start")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.onFiveMinuteInterval = {
                WKInterfaceDevice.current().play(.notification)
            }
        }
    }
    
    private func timeString(from interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
