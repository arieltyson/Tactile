import SwiftUI

struct WaveformView: View {
    // Dependency Injection: Access the Feedback Service
    @Environment(FeedbackService.self) private var feedbackService

    @State private var isRecording = false
    @State private var barHeights: [CGFloat] = Array(repeating: 20, count: 5)

    @State private var selectedContext: RecordingContext = .general

    var body: some View {
        ZStack {
            // Background Layer (The Touch Surface)
            Color.black.opacity(0.01)  // invisible but interactable
                .ignoresSafeArea()

            // Visual Layer (The "Fake" Waveform)
            VStack(spacing: 20) {
                // Visual Indicator of Context (For sighted users)
                Text(selectedContext.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.heavy)
                    .foregroundStyle(.secondary)
                    .tracking(2)
                    // Hide from VO because the Button Value handles it
                    .accessibilityHidden(true)

                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isRecording ? Color.red : Color.primary)
                            .frame(width: 8, height: barHeights[index])
                            .animation(
                                .easeInOut(duration: 0.2),
                                value: barHeights[index]
                            )
                    }
                }
            }
        }
        // The Interaction Logic
        .onTapGesture {
            toggleRecording()
        }

        // Accessibility Configuration
        .accessibilityElement(children: .ignore)  // Merge all bars into one button
        .accessibilityLabel(isRecording ? "Stop Recording" : "Start Recording")
        .accessibilityValue(selectedContext.rawValue)
        .accessibilityAddTraits([.isButton, .isAdjustable])
        .accessibilityHint(
            "Double tap to toggle. Swipe up or down to change context."
        )

        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                cycleContext(to: selectedContext.next)
            case .decrement:
                cycleContext(to: selectedContext.previous)
            @unknown default:
                break
            }
        }

        .accessibilityAction(named: "Next Context") {
            cycleContext(to: selectedContext.next)
        }
    }

    // The Logic Hub
    private func toggleRecording() {
        isRecording.toggle()

        // Haptic Feedback (Immediate physical confirmation)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        // Visual Animation (Mocking audio input for now)
        withAnimation {
            barHeights =
                isRecording
                ? [50, 80, 40, 90, 60] : Array(repeating: 20, count: 5)
        }

        // Audio Feedback (Using our service)
        let message = isRecording ? "Recording Started" : "Recording Paused"
        feedbackService.announce(message)
    }

    private func cycleContext(to newContext: RecordingContext) {
        selectedContext = newContext

        // Haptic "Click" to simulate a dial turning
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()

        // We explicitly announce the value because Adjustable actions
        // don't always auto-announce in custom views.
        feedbackService.announce(newContext.rawValue)
    }
}

#Preview {
    WaveformView()
        .environment(FeedbackService.shared)
}
