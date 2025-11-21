//
//  ConnectivityManager.swift
//  HapticTimer
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
        
        // Sync to Watch
        guard session.activationState == .activated else { return }
        
        let context = ["hapticIntervalMinutes": hapticIntervalMinutes]
        do {
            try session.updateApplicationContext(context)
            print("📱 iOS: Synced interval to Watch: \(hapticIntervalMinutes) min")
        } catch {
            print("📱 iOS: Error syncing to Watch: \(error)")
        }
    }
}

extension ConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("📱 iOS: WCSession activation error: \(error)")
        } else {
            print("📱 iOS: WCSession activated: \(activationState.rawValue)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("📱 iOS: Session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("📱 iOS: Session deactivated, reactivating...")
        session.activate()
    }
    
    // Receive updates from Watch
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            if let interval = applicationContext["hapticIntervalMinutes"] as? Int {
                print("📱 iOS: Received interval from Watch: \(interval) min")
                // Update without triggering didSet to avoid sync loop
                self.hapticIntervalMinutes = interval
                UserDefaults.standard.set(interval, forKey: "hapticIntervalMinutes")
            }
        }
    }
}

