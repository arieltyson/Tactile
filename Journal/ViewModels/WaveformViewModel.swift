import Foundation
import Observation
import UIKit
import SwiftUI

/// ViewModel managing all presentation state and user actions for the WaveformView.
@Observable
@MainActor
final class WaveformViewModel: Sendable {
    var isRecording: Bool = false
    var selectedContext: RecordingContext = .general
    var playbackSpeed: Float = 1.0
    var barHeights: [CGFloat] = Array(repeating: 20, count: 5)

    private var feedbackService = FeedbackService.shared
    private var animationTask: Task<Void, Never>?
    
    // Animation configuration
    private let minHeight: CGFloat = 20
    private let maxHeight: CGFloat = 90
    private let animationInterval: Duration = .milliseconds(100)

    func toggleRecording() {
        isRecording.toggle()

        // Haptic Feedback (Immediate physical confirmation)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        barHeights =
            isRecording
            ? [50, 80, 40, 90, 60] : Array(repeating: 20, count: 5)

        // Audio Feedback (Using our service)
        let message = isRecording ? "Recording Started" : "Recording Paused"
        feedbackService.announce(message)
    }

    func cycleContext(to newContext: RecordingContext) {
        selectedContext = newContext

        // Haptic "Click" to simulate a dial turning
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()

        // We explicitly announce the value because Adjustable actions
        // don't always auto-announce in custom views.
        feedbackService.announce(newContext.rawValue)
    }

    func changePlaybackSpeed(to speed: Float) {
        playbackSpeed = speed
        feedbackService.announce("Speed \(speed)x")
    }
}
