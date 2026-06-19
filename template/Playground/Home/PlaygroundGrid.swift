import SwiftUI

struct PlaygroundGrid: View {
    let onPopBalloon: () -> Void
    let onQuickPacks: () -> Void
    let streak: Int
    let ideaOfDay: PopIdea?
    let bundleTitle: String?

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            gridTile(
                emoji: "🎈",
                title: "Pop a Balloon",
                subtitle: "Tap for today's surprise",
                color: SunnyPalette.primary,
                action: onPopBalloon
            )
            gridTile(
                emoji: "⭐",
                title: "\(streak) Day Streak",
                subtitle: streak > 0 ? "Keep shining!" : "Start your streak",
                color: SunnyPalette.secondary,
                action: {}
            )
            gridTile(
                emoji: ideaOfDay?.emojiTag ?? "💡",
                title: "Idea of the Day",
                subtitle: ideaOfDay?.title ?? "Pop to discover",
                color: SunnyPalette.accent,
                action: onPopBalloon
            )
            gridTile(
                emoji: "🎁",
                title: "Quick Packs",
                subtitle: bundleTitle ?? "8 family packs",
                color: SunnyPalette.primary.opacity(0.8),
                action: onQuickPacks
            )
        }
    }

    private func gridTile(emoji: String, title: String, subtitle: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Text(emoji).font(.system(size: 32))
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(SunnyPalette.text)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(SunnyPalette.mutedText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .frame(height: 130)
            .background(
                RoundedRectangle(cornerRadius: SunnyPalette.pillRadius, style: .continuous)
                    .fill(SunnyPalette.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: SunnyPalette.pillRadius, style: .continuous)
                            .stroke(color.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: color.opacity(0.15), radius: 8, y: 4)
            )
        }
        .buttonStyle(.plain)
    }
}
