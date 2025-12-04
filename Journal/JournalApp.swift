import SwiftUI

@main
struct JournalApp: App {
    // Initialize the service once at app launch
    @StateObject private var feedbackService = FeedbackService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(feedbackService)
        }
    }
}
