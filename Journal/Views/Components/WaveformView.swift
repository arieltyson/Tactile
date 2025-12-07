import SwiftUI

struct WaveformView: View {
    // Dependency Injection: Access the Feedback Service
    @Environment(FeedbackService.self) private var feedbackService
    
    @State private var isRecording = false
    @State private var barHeights: [CGFloat] = Array(repeating: 20, count: 5)
    
    var body: some View {
        ZStack {
            // Background Layer (The Touch Surface)
            Color.black.opacity(0.01) // invisible but interactable
                .ignoresSafeArea()
            
            // Visual Layer (The "Fake" Waveform)
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isRecording ? Color.red : Color.primary)
                        .frame(width: 8, height: barHeights[index])
                        .animation(.easeInOut(duration: 0.2), value: barHeights[index])
                }
            }
        }
        // The Interaction Logic
        .onTapGesture {
            toggleRecording()
        }
        
        // Accessibility Configuration
        .accessibilityElement(children: .ignore) // Merge all bars into one button
        .accessibilityLabel(isRecording ? "Stop Recording" : "Start Recording")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to toggle.")
    }
    
    // The Logic Hub
    private func toggleRecording() {
        isRecording.toggle()
        
        // Haptic Feedback (Immediate physical confirmation)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Visual Animation (Mocking audio input for now)
        withAnimation {
            barHeights = isRecording ? [50, 80, 40, 90, 60] : Array(repeating: 20, count: 5)
        }
        
        // Audio Feedback (Using our service)
        let message = isRecording ? "Recording Started" : "Recording Paused"
        feedbackService.announce(message)
    }
}

#Preview {
    WaveformView()
        .environment(FeedbackService.shared)
}
