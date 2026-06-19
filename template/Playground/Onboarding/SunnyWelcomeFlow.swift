import SwiftUI

struct SunnyWelcomeFlow: View {
    @EnvironmentObject private var services: SunnyFamilyServices
    @State private var page = 0

    private let pages: [WelcomePage] = [
        WelcomePage(emoji: "🎈", title: "Pop ideas together",
                    subtitle: "Tap a balloon and discover a fun family activity hiding inside!", color: SunnyPalette.primary),
        WelcomePage(emoji: "👨‍👩‍👧", title: "Made for families",
                    subtitle: "Parents and kids share playful moments — no screens required for the fun.", color: SunnyPalette.accent),
        WelcomePage(emoji: "⭐", title: "Grow your star streak",
                    subtitle: "Complete daily pops and watch your family streak light up with joy.", color: SunnyPalette.secondary),
        WelcomePage(emoji: "🎁", title: "Packs for every mood",
                    subtitle: "Rainy day? Weekend? After school? Pick a pack and let the balloon decide!", color: SunnyPalette.primary)
    ]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Skip") { finish() }
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(SunnyPalette.mutedText)
            }
            .padding(.horizontal, 20)

            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { idx in
                    welcomePageView(pages[idx]).tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            SunnyPillButton(page == pages.count - 1 ? "Let's Pop!" : "Continue") {
                if page == pages.count - 1 { finish() }
                else { withAnimation { page += 1 } }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .sunnyScreenBackground()
    }

    private func welcomePageView(_ page: WelcomePage) -> some View {
        VStack(spacing: 28) {
            Spacer()
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.15))
                    .frame(width: 180, height: 180)
                Text(page.emoji)
                    .font(.system(size: 72))
            }
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(SunnyPalette.text)
                    .multilineTextAlignment(.center)
                Text(page.subtitle)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(SunnyPalette.mutedText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Spacer()
            Spacer()
        }
    }

    private func finish() {
        Task { @MainActor in
            services.preferences.hasCompletedOnboarding = true
        }
    }
}

private struct WelcomePage {
    let emoji: String
    let title: String
    let subtitle: String
    let color: Color
}
