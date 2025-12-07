import SwiftUI

@main
struct JournalApp: App {
    // Initialize the service once at app launch
    private var feedbackService = FeedbackService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(feedbackService)
        }
    }
}
