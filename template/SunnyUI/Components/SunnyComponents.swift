import SwiftUI

struct SunnyPillButton: View {
    let title: String
    let icon: String?
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    init(_ title: String, icon: String? = nil, isLoading: Bool = false,
         isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button {
            SunnyHaptics.shared.impact(.light)
            action()
        } label: {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView().progressViewStyle(.circular).tint(.white)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 17, weight: .semibold))
                            .symbolRenderingMode(.hierarchical)
                    }
                    Text(title)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(SunnyPalette.sunnyGradient)
            .clipShape(Capsule())
            .shadow(color: SunnyPalette.primary.opacity(0.35), radius: 12, x: 0, y: 6)
            .opacity(isDisabled ? 0.5 : 1)
        }
        .disabled(isDisabled || isLoading)
    }
}

struct SunnyStatTile: View {
    let title: String
    let value: String
    let emoji: String

    var body: some View {
        VStack(spacing: 6) {
            Text(emoji).font(.system(size: 24))
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(SunnyPalette.text)
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(SunnyPalette.mutedText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: SunnyPalette.pillRadius, style: .continuous)
                .fill(SunnyPalette.surface)
                .shadow(color: SunnyPalette.primary.opacity(0.1), radius: 8, y: 3)
        )
    }
}

struct SunnyCard<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: SunnyPalette.pillRadius, style: .continuous)
                    .fill(SunnyPalette.surface)
                    .shadow(color: SunnyPalette.primary.opacity(0.12), radius: 10, y: 4)
            )
    }
}

struct PopStatusBadge: View {
    let status: PopMomentStatus

    var body: some View {
        let info = badgeInfo
        HStack(spacing: 4) {
            Text(info.emoji).font(.system(size: 11))
            Text(info.text)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(info.color.opacity(0.2))
        .foregroundStyle(info.color)
        .clipShape(Capsule())
    }

    private var badgeInfo: (text: String, color: Color, emoji: String) {
        switch status {
        case .completed: ("Done", SunnyPalette.success, "✅")
        case .skipped: ("Skipped", SunnyPalette.mutedText, "⏭️")
        case .savedForLater: ("Saved", SunnyPalette.warning, "💾")
        case .accepted: ("Loved", SunnyPalette.primary, "💛")
        case .popped: ("New", SunnyPalette.accent, "🎈")
        }
    }
}

struct SunnyScreenHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 34, weight: .bold, design: .rounded))
            .foregroundStyle(SunnyPalette.text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 8)
    }
}

struct SunnyEmptyState: View {
    let emoji: String
    let title: String
    let message: String
    var buttonTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: SunnySpacing.md) {
            Text(emoji).font(.system(size: 56))
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(SunnyPalette.text)
            Text(message)
                .font(.system(size: 15, design: .rounded))
                .foregroundStyle(SunnyPalette.mutedText)
                .multilineTextAlignment(.center)
            if let buttonTitle, let action {
                SunnyPillButton(buttonTitle, action: action)
                    .padding(.horizontal, SunnySpacing.xl)
            }
        }
        .padding(SunnySpacing.lg)
    }
}

struct SunnyShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
