import Foundation
import SwiftData

@Model
final class PopIdea {
    @Attribute(.unique) var id: UUID
    var bundleId: UUID
    var number: Int
    var title: String
    var details: String
    var emojiTag: String

    init(
        id: UUID = UUID(),
        bundleId: UUID,
        number: Int,
        title: String,
        details: String = "",
        emojiTag: String = "💡"
    ) {
        self.id = id
        self.bundleId = bundleId
        self.number = number
        self.title = title
        self.details = details
        self.emojiTag = emojiTag
    }
}
