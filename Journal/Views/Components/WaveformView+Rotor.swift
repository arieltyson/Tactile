import SwiftUI

// The View Extension for Accessibility-Specific Logic
extension View {

    /// Applies the custom accessibility rotors for the waveform view.
    /// - Parameter viewModel: The ViewModel holding the action logic.
    func waveformCustomRotors(viewModel: WaveformViewModel) -> some View {
        // We use a view extension to keep the main view's body clean.

        // 1. The Playback Speed Rotor
        self.accessibilityRotor("Playback Speed") {
            AccessibilityRotorEntry(
                "1x",
                id: "1x"
            ) {
                viewModel.changePlaybackSpeed(to: 1.0)
            }
            AccessibilityRotorEntry(
                "2x",
                id: "2x"
            ) {
                viewModel.changePlaybackSpeed(to: 2.0)
            }
            AccessibilityRotorEntry(
                "0.5x",
                id: "0.5x"
            ) {
                viewModel.changePlaybackSpeed(to: 0.5)
            }
        }
    }
}
