import AVFoundation
import Foundation
import Observation
import UIKit

/// The central authority for application feedback.
///
/// This service acts as a facade, intelligently routing feedback to either
/// the system Accessibility engine (VoiceOver) or the internal audio engine (AVSpeechSynthesizer).
@Observable
@MainActor
final class FeedbackService: Sendable {

    /// Shared singleton instance for global access
    /// Marked @MainActor to ensure safe global access
    @MainActor
    static let shared = FeedbackService()

    /// Indicates whether VoiceOver is currently running
    private(set) var isVoiceOverEnabled: Bool

    private let synthesizer = AVSpeechSynthesizer()

    private init() {
        self.isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning

        Task { @MainActor in
            await configureAudioSession()
            monitorVoiceOverStatus()
        }
    }

    /// Triggers an audio announcement appropriate for the current user state.
    ///
    /// When VoiceOver is enabled, this method posts an announcement to the Accessibility system.
    /// When VoiceOver is disabled, it uses AVSpeechSynthesizer to provide audio feedback.
    ///
    /// - Parameter message: The text to be spoken
    func announce(_ message: String) {
        guard !message.isEmpty else { return }

        if isVoiceOverEnabled {
            // Phase 1: VoiceOver Mode
            // Post a notification to the Accessibility system.
            // We use .announcement to interrupt current speech gracefully.
            UIAccessibility.post(notification: .announcement, argument: message)
        } else {
            // Phase 2: "Eyes-Free" Mode (Sighted users)
            // Use internal synth to mimic VoiceOver behavior.
            let utterance = AVSpeechUtterance(string: message)

            utterance.rate = AVSpeechUtteranceDefaultSpeechRate
            utterance.prefersAssistiveTechnologySettings = true

            synthesizer.speak(utterance)
        }
    }

    /// Monitors VoiceOver status changes using modern async/await patterns
    private func monitorVoiceOverStatus() {
        // We fire and forget this task. It lives as long as 'self' lives.
        Task { @MainActor [weak self] in
            let notifications = NotificationCenter.default.notifications(
                named: UIAccessibility.voiceOverStatusDidChangeNotification
            )

            for await _ in notifications {
                guard let self else { return }
                // Update the state dynamically when the user toggles VoiceOver
                self.isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning
            }
        }
    }

    /// Configures the audio session for optimal speech playback
    ///
    /// This ensures audio plays even when the Ring/Silent switch is set to Silent,
    /// which is critical for an audio-first app.
    private func configureAudioSession() async {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(
                .playback,
                mode: .spokenAudio,
                options: [.duckOthers]
            )
            try audioSession.setActive(true)
        } catch {
            // In production, consider using OSLog or your logging framework
            print(
                "⚠️ Failed to configure audio session: \(error.localizedDescription)"
            )
        }
    }
}
