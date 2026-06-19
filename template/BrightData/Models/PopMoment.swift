import Foundation
import SwiftData

@Model
final class PopMoment {
    @Attribute(.unique) var id: UUID
    var bundleId: UUID
    var bundleTitle: String
    var ideaTitle: String
    var ideaDetails: String
    var emojiTag: String
    var poppedAt: Date
    var statusRaw: String
    var sourceRaw: String
    var streakDay: Int

    var status: PopMomentStatus {
        get { PopMomentStatus(rawValue: statusRaw) ?? .popped }
        set { statusRaw = newValue.rawValue }
    }

    var source: PopSource {
        get { PopSource(rawValue: sourceRaw) ?? .dailyBalloon }
        set { sourceRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        bundleId: UUID,
        bundleTitle: String,
        ideaTitle: String,
        ideaDetails: String = "",
        emojiTag: String = "💡",
        poppedAt: Date = .now,
        status: PopMomentStatus = .popped,
        source: PopSource = .dailyBalloon,
        streakDay: Int = 0
    ) {
        self.id = id
        self.bundleId = bundleId
        self.bundleTitle = bundleTitle
        self.ideaTitle = ideaTitle
        self.ideaDetails = ideaDetails
        self.emojiTag = emojiTag
        self.poppedAt = poppedAt
        self.statusRaw = status.rawValue
        self.sourceRaw = source.rawValue
        self.streakDay = streakDay
    }
}
