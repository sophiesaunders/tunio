//
//  PermissionsChecker.swift
//  tunio
//
//  Created by Sophie Saunders on 6/10/24.
//

import AVFoundation // AVAudioApplication
import AudioKit // Settings

class PermissionsChecker {
    
    static func getMicrophoneAccess() async {
        if #available(iOS 17.0, *) {
            let permission = AVAudioApplication.shared.recordPermission
            switch permission {
                case .granted: return
                case .denied: fatalError()
                case .undetermined: break
                default: break
            }
            
            await AVAudioApplication.requestRecordPermission()
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
                fatalError()
            }
        #endif
    }
}
