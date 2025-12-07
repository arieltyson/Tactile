import Foundation

/// Represents the semantic category of a recording.
/// Conforms to `CaseIterable` for easy cycling and `Identifiable` for SwiftUI loops.
enum RecordingContext: String, CaseIterable, Identifiable, Sendable {
    case general = "General"
    case work = "Work"
    case personal = "Personal"
    case ideas = "Ideas"
    
    var id: String { self.rawValue }
    
    /// Returns the next context in the cycle.
    var next: RecordingContext {
        let all = Self.allCases
        let idx = all.firstIndex(of: self) ?? 0
        let nextIdx = (idx + 1) % all.count
        return all[nextIdx]
    }
    
    /// Returns the previous context in the cycle.
    var previous: RecordingContext {
        let all = Self.allCases
        let idx = all.firstIndex(of: self) ?? 0
        let prevIdx = (idx - 1 + all.count)  % all.count
        return all[prevIdx]
    }
}
