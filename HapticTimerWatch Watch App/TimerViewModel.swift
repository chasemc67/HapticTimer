import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    
    private var timer: Timer?
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    private var lastHapticInterval: Int = 0
    
    // Called when a 5-minute interval is reached
    var onFiveMinuteInterval: (() -> Void)?
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.elapsedTime = self.accumulatedTime + Date().timeIntervalSince(startTime)
            
            // Check for 5-minute intervals
            let interval = Int(self.elapsedTime) / 300
            if interval > self.lastHapticInterval {
                self.lastHapticInterval = interval
                self.onFiveMinuteInterval?()
            }
        }
    }
    
    func stop() {
        isRunning = false
        if let startTime = startTime {
            accumulatedTime += Date().timeIntervalSince(startTime)
        }
        timer?.invalidate()
        timer = nil
        startTime = nil
    }
    
    func reset() {
        stop()
        elapsedTime = 0
        accumulatedTime = 0
        lastHapticInterval = 0
    }
} 