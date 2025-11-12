//
//  ContentView.swift
//  HapticTimerWatch Watch App
//
//  Created by Chase McCarty on 5/18/25.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    @AppStorage("hapticIntervalMinutes") private var hapticIntervalMinutes: Int = 5
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Time display at top
                Spacer()
                    .frame(height: 20)
                
                Text(timeString(from: viewModel.elapsedTime))
                    .font(.system(size: 48, weight: .light, design: .monospaced))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Spacer()
                
                // Bottom buttons
                HStack(spacing: 0) {
                    // Left button - Reset
                    Button(action: {
                        viewModel.reset()
                    }) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("Reset")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.elapsedTime == 0)
                    .opacity(viewModel.elapsedTime == 0 ? 0.5 : 1)
                    
                    Spacer()
                    
                    // Right button - Start/Stop
                    Button(action: {
                        if viewModel.isRunning {
                            viewModel.stop()
                        } else {
                            viewModel.start()
                        }
                    }) {
                        Circle()
                            .fill(viewModel.isRunning ? Color.red.opacity(0.3) : Color.green.opacity(0.3))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(viewModel.isRunning ? "Stop" : "Start")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(viewModel.isRunning ? .red : .green)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .onAppear {
            setupHapticFeedback()
        }
        .onChange(of: hapticIntervalMinutes) { _, newValue in
            viewModel.hapticIntervalMinutes = newValue
        }
    }
    
    private func setupHapticFeedback() {
        viewModel.hapticIntervalMinutes = hapticIntervalMinutes
        viewModel.onHapticInterval = { count in
            playHapticSequence(count: count)
        }
    }
    
    private func playHapticSequence(count: Int) {
        for i in 0..<count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                WKInterfaceDevice.current().play(.start)
            }
        }
    }
    
    private func timeString(from interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        let centiseconds = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, centiseconds)
        } else {
            return String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)
        }
    }
}

#Preview {
    ContentView()
}
