//
//  PermissionsChecker.swift
//  Tunio
//
//  Created by Sophie Saunders on 6/10/24.
//

import AVFoundation // AVAudioApplication
import AudioKit // Settings

class PermissionsChecker {
    
    static func getMicrophoneAccess() async -> Bool {
        if #available(iOS 17.0, *) {
            let permission = AVAudioApplication.shared.recordPermission
            switch permission {
                case .granted: return true
                case .denied: return false
                default: return await AVAudioApplication.requestRecordPermission()
            }
        }
    }
    
    static func setSessionParameters() {
        #if os(iOS)
            do {
                Settings.bufferLength = .short
                try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers, .allowBluetooth])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to configure AVAudioSession.")
            }
        #endif
    }
}
