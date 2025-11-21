//
//  ConnectivityManager.swift
//  HapticTimerWatch Watch App
//
//  Created by Chase McCarty on 11/21/25.
//

import Foundation
import WatchConnectivity

class ConnectivityManager: NSObject, ObservableObject {
    static let shared = ConnectivityManager()
    
    @Published var hapticIntervalMinutes: Int = 5 {
        didSet {
            saveAndSync()
        }
    }
    
    private let session = WCSession.default
    
    private override init() {
        super.init()
        
        // Load saved value
        let saved = UserDefaults.standard.integer(forKey: "hapticIntervalMinutes")
        hapticIntervalMinutes = saved > 0 ? saved : 5
        
        // Setup WatchConnectivity
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    private func saveAndSync() {
        // Save locally
        UserDefaults.standard.set(hapticIntervalMinutes, forKey: "hapticIntervalMinutes")
        
        // Sync to iPhone
        guard session.activationState == .activated else { return }
        
        let context = ["hapticIntervalMinutes": hapticIntervalMinutes]
        do {
            try session.updateApplicationContext(context)
            print("⌚️ Watch: Synced interval to iPhone: \(hapticIntervalMinutes) min")
        } catch {
            print("⌚️ Watch: Error syncing to iPhone: \(error)")
        }
    }
}

extension ConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("⌚️ Watch: WCSession activation error: \(error)")
        } else {
            print("⌚️ Watch: WCSession activated: \(activationState.rawValue)")
        }
    }
    
    // Receive updates from iPhone
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            if let interval = applicationContext["hapticIntervalMinutes"] as? Int {
                print("⌚️ Watch: Received interval from iPhone: \(interval) min")
                // Update without triggering didSet to avoid sync loop
                self.hapticIntervalMinutes = interval
                UserDefaults.standard.set(interval, forKey: "hapticIntervalMinutes")
            }
        }
    }
}

