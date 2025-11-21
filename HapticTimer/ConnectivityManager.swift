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
            guard oldValue != hapticIntervalMinutes else { return }
            saveAndSync()
        }
    }
    
    private let session = WCSession.default
    private var isSyncing = false
    private var isSessionActivated = false
    private var pendingSync = false
    
    private override init() {
        super.init()
        
        // Load saved value first
        let saved = UserDefaults.standard.integer(forKey: "hapticIntervalMinutes")
        let initialValue = saved > 0 ? saved : 5
        
        // Set without triggering didSet
        _hapticIntervalMinutes = Published(initialValue: initialValue)
        print("📱 iOS: Loaded initial interval: \(initialValue) min")
        
        // Setup WatchConnectivity after loading value
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        } else {
            print("📱 iOS: WatchConnectivity not supported")
        }
    }
    
    private func saveAndSync() {
        guard !isSyncing else { return }
        
        // Save locally
        UserDefaults.standard.set(hapticIntervalMinutes, forKey: "hapticIntervalMinutes")
        
        // Check if session is ready
        guard isSessionActivated else {
            print("📱 iOS: Session not ready yet, will sync when activated")
            pendingSync = true
            return
        }
        
        syncToWatch()
    }
    
    private func syncToWatch() {
        guard session.activationState == .activated else {
            print("📱 iOS: Session not activated")
            return
        }
        
        guard session.isPaired else {
            print("📱 iOS: Watch not paired")
            return
        }
        
        guard session.isWatchAppInstalled else {
            print("📱 iOS: Watch app not installed")
            return
        }
        
        let context = ["hapticIntervalMinutes": hapticIntervalMinutes]
        do {
            try session.updateApplicationContext(context)
            print("📱 iOS: ✅ Synced interval to Watch: \(hapticIntervalMinutes) min")
            pendingSync = false
        } catch {
            print("📱 iOS: ❌ Error syncing to Watch: \(error.localizedDescription)")
        }
    }
}

extension ConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("📱 iOS: ❌ WCSession activation error: \(error.localizedDescription)")
            return
        }
        
        print("📱 iOS: ✅ WCSession activated successfully")
        print("📱 iOS: Paired: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")
        
        isSessionActivated = true
        
        // Sync any pending changes
        if pendingSync {
            print("📱 iOS: Syncing pending change...")
            syncToWatch()
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
                // Update without triggering sync back
                self.isSyncing = true
                self.hapticIntervalMinutes = interval
                UserDefaults.standard.set(interval, forKey: "hapticIntervalMinutes")
                self.isSyncing = false
            }
        }
    }
}

