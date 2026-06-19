import Foundation

enum PopMomentStatus: String, Codable, CaseIterable {
    case popped
    case completed
    case skipped
    case savedForLater
    case accepted

    var label: String {
        switch self {
        case .popped: "Popped"
        case .completed: "Done"
        case .skipped: "Skipped"
        case .savedForLater: "Saved"
        case .accepted: "Loved it"
        }
    }
}

enum PopSource: String, Codable {
    case dailyBalloon
    case quickPack
    case customBundle
    case carousel
}
