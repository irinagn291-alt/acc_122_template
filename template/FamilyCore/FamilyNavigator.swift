import SwiftUI

enum SunnyTab: Int, CaseIterable, Identifiable {
    case playground, packs, joy, insights, settings

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .playground: "Play"
        case .packs: "Packs"
        case .joy: "Joy"
        case .insights: "Stars"
        case .settings: "More"
        }
    }

    var emoji: String {
        switch self {
        case .playground: "🎈"
        case .packs: "🎁"
        case .joy: "💛"
        case .insights: "⭐"
        case .settings: "☀️"
        }
    }
}

struct SunnyBottomNav: View {
    @Binding var selected: SunnyTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(SunnyTab.allCases) { tab in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selected = tab
                    }
                    SunnyHaptics.shared.impact(.light)
                } label: {
                    VStack(spacing: 4) {
                        Text(tab.emoji)
                            .font(.system(size: selected == tab ? 26 : 22))
                            .scaleEffect(selected == tab ? 1.1 : 1.0)
                        Text(tab.title)
                            .font(.system(size: 10, weight: selected == tab ? .bold : .medium, design: .rounded))
                            .foregroundStyle(selected == tab ? SunnyPalette.text : SunnyPalette.mutedText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(.horizontal, 8)
        .background {
            Capsule()
                .fill(SunnyPalette.surface)
                .shadow(color: SunnyPalette.primary.opacity(0.15), radius: 16, y: 6)
                .overlay(
                    Capsule()
                        .stroke(SunnyPalette.secondary.opacity(0.5), lineWidth: 2)
                )
        }
        .padding(.horizontal, 16)
    }
}

struct FamilyMainShell: View {
    @State private var selectedTab: SunnyTab = .playground

    var body: some View {
        ZStack(alignment: .bottom) {
            SunnyPalette.backgroundGradient.ignoresSafeArea()

            Group {
                switch selectedTab {
                case .playground: CarouselHomeView()
                case .packs: PackCatalogView()
                case .joy: JoyArchiveView()
                case .insights: FamilyInsightsView()
                case .settings: SunnySettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            SunnyBottomNav(selected: $selectedTab)
                .padding(.bottom, 12)
        }
        .preferredColorScheme(.light)
    }
}

struct FamilyNavigator: View {
    @EnvironmentObject private var services: SunnyFamilyServices

    var body: some View {
        Group {
            if services.preferences.hasCompletedOnboarding {
                FamilyMainShell()
            } else {
                SunnyWelcomeFlow()
            }
        }
    }
}
