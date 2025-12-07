import SwiftUI

struct WaveformView: View {
    @State private var viewModel = WaveformViewModel()

    var body: some View {
        ZStack {
            // Background Layer (The Touch Surface)
            Color.black.opacity(0.01)  // invisible but interactable
                .ignoresSafeArea()

            // Visual Layer (The "Fake" Waveform)
            VStack(spacing: 20) {
                // Visual Indicator of Context (For sighted users)
                Text(viewModel.selectedContext.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.heavy)
                    .foregroundStyle(.secondary)
                    .tracking(2)
                    // Hide from VO because the Button Value handles it
                    .accessibilityHidden(true)

                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(viewModel.isRecording ? Color.red : Color.primary)
                            .frame(width: 8, height: viewModel.barHeights[index])
                            .animation(
                                .easeInOut(duration: 0.2),
                                value: viewModel.barHeights[index]
                            )
                    }
                }
            }
        }
        // The Interaction Logic
        .onTapGesture {
            viewModel.toggleRecording()
        }

        // Accessibility Configuration
        .accessibilityElement(children: .ignore)  // Merge all bars into one button
        .accessibilityLabel(
            viewModel.isRecording ? "Stop Recording" : "Start Recording"
        )
        .accessibilityValue(
            "\(viewModel.selectedContext.rawValue), Speed \(viewModel.playbackSpeed)x"
        )
        .accessibilityHint(
            "Double tap to toggle. Swipe up or down to change context."
        )
        .accessibilityAddTraits(.isButton)

        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                viewModel.cycleContext(to: viewModel.selectedContext.next)
            case .decrement:
                viewModel.cycleContext(to: viewModel.selectedContext.previous)
            @unknown default:
                break
            }
        }

        .waveformCustomRotors(viewModel: viewModel)
    }
}

#Preview {
    WaveformView()
        .environment(FeedbackService.shared)
}
