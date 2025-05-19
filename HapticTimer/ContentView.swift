//
//  ContentView.swift
//  HapticTimer
//
//  Created by Chase McCarty on 5/18/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text(timeString(from: viewModel.elapsedTime))
                .font(.system(size: 48, weight: .medium, design: .monospaced))
            
            Button(action: {
                if viewModel.isRunning {
                    viewModel.stop()
                } else {
                    viewModel.start()
                }
            }) {
                Text(viewModel.isRunning ? "Stop" : "Start")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            Button(action: {
                viewModel.reset()
            }) {
                Text("Reset")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
            Spacer()
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
