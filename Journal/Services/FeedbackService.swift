import Foundation
import AVFoundation
import UIKit
import Combine

/// The central authority for application feedback.
/// This service acts as a facade, intelligently routing feedback to either
/// the system Accessibility engine (VoiceOver) or the internal Audio engine (AVSpeechSynthesizer).
@MainActor
final class FeedbackService: ObservableObject {
    
    /// Shared singleton instance for global access
    static let shared = FeedbackService()
    
    @Published private(set) var isVoiceOverEnabled: Bool = UIAccessibility.isVoiceOverRunning
    
    private let synthesizer = AVSpeechSynthesizer()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        monitorVoiceOverStatus()
        configureAudioSession()
    }
    
    /// Triggers an audio announcement appropriate for the current user state.
    /// - Parameter message: The text to be spoken
    func announce(_ message: String) {
        if isVoiceOverEnabled {
            // Phase 1: VoiceOver Mode
            // Post a notification to the Accessibility system.
            // We use .announcement to interrupt current speech gracefully.
            UIAccessibility.post(notification: .announcement, argument: message)
        } else {
            // Phase 2: "Eyes-Free" Mode (Sighter users)
            // Use internal synth to mimic VoiceOver behaviour.
            let utterance = AVSpeechUtterance(string: message)
            utterance.rate = 0.5 // Neutral speaking rate
            synthesizer.speak(utterance)
        }
    }
    
    private func monitorVoiceOverStatus() {
        NotificationCenter.default.publisher(for: UIAccessibility.voiceOverStatusDidChangeNotification)
            .sink { [weak self] _ in
                guard let self else { return }
                // Update the state dynamically if the user toggles VoiceOver
                self.isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning
            }
            .store(in: &cancellables)
    }
    
    private func configureAudioSession() {
        // Ensure audio plays even if the Ring/Silent switch is set to Silent.
        // This is critical for an audio-first app.
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure AudioSession: \(error)")
        }
    }
}
