import Foundation
import SwiftData

enum FamilyTheme: String, CaseIterable, Codable {
    case together = "together"
    case outdoor = "outdoor"
    case creative = "creative"
    case kitchen = "kitchen"
    case quiet = "quiet"
    case weekend = "weekend"
    case custom = "custom"

    var label: String {
        switch self {
        case .together: "Together Time"
        case .outdoor: "Outdoor Fun"
        case .creative: "Creative Play"
        case .kitchen: "Kitchen Joy"
        case .quiet: "Cozy Moments"
        case .weekend: "Weekend Magic"
        case .custom: "My Pack"
        }
    }

    var emoji: String {
        switch self {
        case .together: "👨‍👩‍👧"
        case .outdoor: "🌳"
        case .creative: "🎨"
        case .kitchen: "🍳"
        case .quiet: "📖"
        case .weekend: "🎉"
        case .custom: "✨"
        }
    }
}

@Model
final class BalloonBundle {
    @Attribute(.unique) var id: UUID
    var title: String
    var themeRaw: String
    var iconName: String
    var colorHex: String
    var createdAt: Date
    var updatedAt: Date
    var isBuiltIn: Bool
    var isArchived: Bool
    var sortOrder: Int
    var builtInKey: String?
    @Relationship(deleteRule: .cascade)
    var ideas: [PopIdea] = []

    var theme: FamilyTheme {
        get { FamilyTheme(rawValue: themeRaw) ?? .custom }
        set { themeRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        title: String,
        theme: FamilyTheme,
        iconName: String,
        colorHex: String,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        isBuiltIn: Bool = false,
        isArchived: Bool = false,
        sortOrder: Int = 0,
        builtInKey: String? = nil,
        ideas: [PopIdea] = []
    ) {
        self.id = id
        self.title = title
        self.themeRaw = theme.rawValue
        self.iconName = iconName
        self.colorHex = colorHex
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isBuiltIn = isBuiltIn
        self.isArchived = isArchived
        self.sortOrder = sortOrder
        self.builtInKey = builtInKey
        self.ideas = ideas
    }

    var sortedIdeas: [PopIdea] {
        ideas.sorted { $0.number < $1.number }
    }
}
