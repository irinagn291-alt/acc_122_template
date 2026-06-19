import UIKit

final class SunnyHaptics {
    static let shared = SunnyHaptics()
    private var enabled = true

    private init() {}

    func setEnabled(_ value: Bool) { enabled = value }

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard enabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard enabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
